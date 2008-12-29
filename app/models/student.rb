# == Schema Information
# Schema version: 20081227220234
#
# Table name: students
#
#  id          :integer         not null, primary key
#  district_id :integer
#  last_name   :string(255)
#  first_name  :string(255)
#  number      :string(255)
#  id_district :integer
#  id_state    :integer
#  id_country  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  birthdate   :date
#

class Student < ActiveRecord::Base
  belongs_to :district
  has_and_belongs_to_many :groups
  has_many :checklists
  has_many :recommendations
  has_many :enrollments
  has_many :schools, :through=>:enrollments
  has_many :comments, :class_name=>"StudentComment"
  has_many :principal_overrides
  has_many :interventions
  has_many :system_flags
  has_many :custom_flags
  has_many :ignore_flags
  has_many :flags

  validates_presence_of :first_name, :last_name, :district_id
  validates_uniqueness_of :id_district, :scope=>:district_id, :unless => lambda {|e| e.id_district.blank?}

  delegate :recommendation_definition, :to => :checklist_definition
  acts_as_reportable if defined? Ruport
  
  after_update :save_system_flags
  
  #This is duplicated in user
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
    return district.checklist_definitions.active_checklist_definition if checklists.empty? or latest_checklist.promoted?
    latest_checklist
  end

  def max_tier
    unless recommendations.blank?
      district.tiers.first
      #FIXME, should only be promoted 
#      district.tiers.find_by_position(recommendations.last.tier.position+1) || district.tiers.find_by_position(recommendations.last.tier.position)
    else
      district.tiers.first
    end
  end

  def self.find_flagged_students(flagtypes=[])
    flagtype=Array(flagtypes)
    stitypes=[]
    custom=flagtype.reject!{|v| v =="custom"}
    ignore=flagtype.reject!{|v| v == "ignored"}
    flagtype.reject!{|v| !Flag::TYPES.keys.include?(v)}

    flagtype=Flag::FLAGTYPES.keys if flagtype.blank?

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
    grades=enrollments.collect(&:grade)
    schools=enrollments.collect(&:school_id)
    principals=[]

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

  
  def save_system_flags
    system_flags.each do |system_flag|
      system_flag.save(false)
    end
  end


  def district_system_flags=(district_flags)
    district_flags = Array(district_flags)
    district_flags.reject!(&:blank?)
    district_flags = district_flags.inject([]) { |result,h| result << h unless result.include?(h); result }
    self.system_flags = district_flags.uniq.collect{|s| SystemFlag.new(s.merge(:student_id=>self.id))}
  end


  def school_enrollments=(enrolled_schs)
    enrolled_schs = Array(enrolled_schs)
    enrolled_schs.reject!(&:blank?)

    #This removes duplicates,  uniq doesn't work with an array of hashes (they're different objects with the same contents.)
    enrolled_schs = enrolled_schs.inject([]) { |result,h| result << h unless result.include?(h); result }

    self.enrollments = enrolled_schs.uniq.collect{|s| Enrollment.new(s.merge(:student_id=>self.id))}
  end

end
