# == Schema Information
# Schema version: 20090212222347
#
# Table name: students
#
#  id                            :integer         not null, primary key
#  district_id                   :integer
#  last_name                     :string(255)
#  first_name                    :string(255)
#  number                        :string(255)
#  id_district                   :integer
#  id_state                      :integer
#  id_country                    :integer
#  created_at                    :datetime
#  updated_at                    :datetime
#  birthdate                     :date
#  esl                           :boolean
#  special_ed                    :boolean
#  extended_profile_file_name    :string(255)
#  extended_profile_content_type :string(255)
#  extended_profile_file_size    :integer
#  extended_profile_updated_at   :datetime
#

class Student < ActiveRecord::Base
  belongs_to :district
  has_and_belongs_to_many :groups
  has_many :checklists
  has_many :recommendations
  has_many :enrollments, :dependent => :destroy
  has_many :schools, :through => :enrollments
  has_many :comments, :class_name => "StudentComment"
  has_many :principal_overrides
  has_many :interventions
  has_many :system_flags
  has_many :custom_flags
  has_many :ignore_flags
  has_many :flags

  has_attached_file  :extended_profile
  attr_reader :delete_extended_profile

  validates_presence_of :first_name, :last_name, :district_id
  validates_uniqueness_of :id_district, :scope => :district_id, :unless => lambda {|e| e.id_district.blank?}
  
  delegate :recommendation_definition, :to => :checklist_definition
  acts_as_reportable if defined? Ruport

  after_update :save_system_flags, :save_enrollments
  before_validation :clear_extended_profile

  # This is duplicated in user
  def fullname 
    first_name.to_s + ' ' + last_name.to_s
  end

  def fullname_last_first
    last_name.to_s + ', ' + first_name.to_s
  end

  def latest_checklist
    checklists.find(:first ,:order => "created_at DESC")
  end

  def checklist_definition
    return district.active_checklist_definition if checklists.empty? or latest_checklist.promoted?
    latest_checklist
  end

  def max_tier
    l_tier=Tier.last
    if principal_overrides.exists?(:end_tier_id => l_tier)
      return l_tier
    elsif recommendations.exists?(:promoted => true)
      return l_tier
    else
      return Tier.first
    end

    
    unless recommendations.blank?
      #TODO Tiers should be specific to district
      Tier.first
      # FIXME, should only be promoted 
#      district.tiers.find_by_position(recommendations.last.tier.position+1) || district.tiers.find_by_position(recommendations.last.tier.position)
    else
      Tier.first
    end
  end

  def self.find_flagged_students(flagtypes=[])
    flagtype = Array(flagtypes)
    stitypes = []
    custom = flagtype.reject!{|v| v =="custom"}
    ignore = flagtype.reject!{|v| v == "ignored"}
    flagtype.reject!{|v| !Flag::TYPES.keys.include?(v)}

    flagtype = Flag::FLAGTYPES.keys if flagtype.blank?

    stitypes << "CustomFlag" if custom
    stitypes << "IgnoreFlag" if ignore

    if stitypes.any?
      find(:all,:include=>:flags,:conditions=>["type in (?) and flagtype in (?)",stitypes,flagtype])
    else
      find(:all,:include=>:flags,:joins=>"left outer join flags as ig on ig.flagtype=flags.flagtype and ig.type='IgnoreFlag' and ig.person_id=flags.person_id",:conditions=>["ig.flagtype is null and flags.flagtype in (?)",flagtype])
    end
  end

  def principals
    #Find principals for student 
    #TODO combine groups and special groups and get their principals
    principals = groups.collect(&:principals)

    principals |= special_group_principals
    principals.flatten.uniq
  end

  def to_s
    fullname
  end

  def self.paged_by_last_name(last_name="", page="1")
    paginate :per_page => 25, :page => page, 
      :conditions=> ['last_name like ?', "%#{last_name}%"],
      :order => 'last_name'
  end

  def special_group_principals
    grades = enrollments.collect(&:grade)
    schools = enrollments.collect(&:school_id)
    principals = []

    principals << district.special_user_groups.principal.all_students_in_district.collect(&:user)
    schools.each do |school|
      principals << district.special_user_groups.principal.all_students_in_school(school).collect(&:user)
      principals << district.special_user_groups.principal.find_all_by_grouptype_and_grade(SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, grades).collect(&:user)
    end

    principals
  end

  def new_system_flag_attributes=(system_flag_attributes)
    system_flag_attributes.each do |attributes|
      system_flags.build(attributes)
    end
  end

  def existing_system_flag_attributes=(system_flag_attributes)
    system_flags.reject(&:new_record?).each do |system_flag|
      attributes = system_flag_attributes[system_flag.id.to_s]
      if attributes
        system_flag.attributes = attributes
      else
        system_flags.delete(system_flag)
      end
    end
  end
  
  def save_enrollments
    enrollments.each do |enrollment|
      enrollment.save(false)
    end
  end

  def new_enrollment_attributes=(enrollment_attributes)
    enrollment_attributes.each do |attributes|
      enrollments.build(attributes)
    end
  end

  def existing_enrollment_attributes=(enrollment_attributes)
    enrollments.reject(&:new_record?).each do |enrollment|
      attributes = enrollment_attributes[enrollment.id.to_s]
      if attributes
        enrollment.attributes = attributes
      else
        enrollments.delete(enrollment)
      end
    end
  end
  
  def save_system_flags
    system_flags.each do |system_flag|
      system_flag.save(false)
    end
  end

  def belongs_to_user?(user)
    user.groups.find_by_id(group_ids) || user.special_user_groups.find_by_school_id(school_ids)
  end

  def active_interventions
    interventions.select(&:active)
  end

  def inactive_interventions
    interventions.reject(&:active)
  end

  def current_flags
    #FIXME doesn't handle ignores
    # all.group_by(&:category)
    flags.reject do |f|
      (f[:type] == 'IgnoreFlag') or 
      (f[:type] == 'SystemFlag' and ignore_flags.any?{|igf| igf.category == f.category})
    end.group_by(&:category)
  end


  def delete_extended_profile=(value)
    @delete_extended_profile = !value.to_i.zero?
  end
  
  def clear_extended_profile
    self.extended_profile=nil if @delete_extended_profile && !extended_profile.dirty?
  end
end
