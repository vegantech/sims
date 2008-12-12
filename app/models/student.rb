# == Schema Information
# Schema version: 20081208201532
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
  has_many :flags do
    def custom_summary
      custom.collect(&:summary)
    end

    def custom
      find_all_by_type('CustomFlag')
    end
    
    def current
      group_by(&:category)
    end
  end

  delegate :recommendation_definition, :to => :checklist_definition
  acts_as_reportable if defined? Ruport

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

end