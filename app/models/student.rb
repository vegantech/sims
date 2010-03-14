# == Schema Information
# Schema version: 20090623023153
#
# Table name: students
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  last_name   :string(255)
#  first_name  :string(255)
#  number      :string(255)
#  district_student_id :integer(4)
#  id_state    :integer(4)
#  id_country  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  birthdate   :date
#  esl         :boolean(1)
#  special_ed  :boolean(1)
#  middle_name :string(255)
#  suffix      :string(255)
#

class Student < ActiveRecord::Base

  include FullName
  belongs_to :district
  has_and_belongs_to_many :groups
  has_many :checklists
  has_many :recommendations
  has_many :enrollments, :dependent => :destroy
  has_many :schools, :through => :enrollments
  has_many :comments, :class_name => "StudentComment", :order => 'created_at desc'
  has_many :principal_overrides
  has_many :interventions
  has_many :system_flags
  has_many :custom_flags
  has_many :ignore_flags
  has_many :flags
  has_many :team_consultations
  has_many :consultation_form_requests
  has_one :ext_arbitrary
  has_many :ext_siblings
  has_many :ext_adult_contacts, :order => "guardian desc"
  has_many :ext_test_scores, :order => "date"
  has_one :ext_summary


  

  validates_presence_of :first_name, :last_name, :district_id
  validates_uniqueness_of :district_student_id, :scope => :district_id, :allow_blank => true
  #validates_uniqueness_of :id_state, :allow_nil => true 
  validate :unique_id_state_by_state

  delegate :state_id, :to => '(district or return nil)'
  delegate :recommendation_definition, :to => :checklist_definition
  acts_as_reportable if defined? Ruport

  before_save :nullify_blank_district_student_id
  after_update :save_system_flags, :save_enrollments
  after_save :save_extended_profile
  #  before_validation :clear_extended_profile


  named_scope :by_state_id_and_id_state, lambda { |state_id, id_state| 
    {:joins=>:district, :conditions => {:districts=>{:state_id => state_id}, :id_state => id_state}, :limit =>1}
  }

  def extended_profile?
    ext_arbitrary.present? || ext_siblings || ext_adult_contacts || ext_test_scores || ext_summary
  end

  def extended_profile
    ext_arbitrary.to_s
 end

  def extended_profile= file
    @extended_profile = file
  end

  def latest_checklist
    checklists.find(:first ,:order => "created_at DESC")
  end

  def checklist_definition
    return district.active_checklist_definition if checklists.empty? or latest_checklist.promoted?
    latest_checklist.checklist_definition
  end

  def max_tier
    # Return the student's highest unlocked tier, defaults to lowest tier in district
    # this will be the highest permitted intervention tier for this student.
    district_tier= district.present? ? district.tiers.first : nil

    [
      district_tier, 
      checklists.max_tier,
      recommendations.max_tier, 
      principal_overrides.max_tier
    ].compact.max
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
    principals.flatten.compact.uniq
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
    user.groups.find_by_id(group_ids) || user.special_user_groups.find_by_school_id(school_ids) || user.special_user_groups.find_by_grouptype(SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT)
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


  def find_checklist(checklist_id, show=true)
    if show
      @checklist=checklists.find(checklist_id,:include=>{:answers=>:answer_definition})
      @checklist.score_checklist if @checklist.show_score?
      @checklist
    else
      @checklist=checklists.find(checklist_id)
    end
  end

  def all_staff_for_student
    (groups.collect(&:users) | special_group_principals).flatten.compact.uniq
  end

  def remove_from_district
    #TODO delete the student if they aren't in use anymore
    enrollments.destroy_all
    groups.clear
    update_attribute(:district_id,nil)
  end

  def unique_id_state_by_state
    if id_state.present? and state_id.present?
      other_student = Student.by_state_id_and_id_state(state_id, id_state).first
      if other_student && other_student != self
        errors.add(:id_state, "Student with #{self.id_state} already exists in #{other_student.district}")
      end
    end
  end

  def pending_consultation_forms
    ConsultationForm.all(:joins => :team_consultation, :conditions => {:team_consultations => {:complete => false, :student_id => self.id}})
  end

  def self.authorized_for_user(user,num=:all, options = {})
    #works for all students in school
    enrollment_join = "inner join enrollments on enrollments.student_id = students.id"  unless  self.scoped_methods.any?{|k|  k[:find] && k[:find][:joins].include?('enrollments')}

    with_scope :find => options do
      find(num,
           :joins => "
            #{enrollment_join}
            left outer join ( groups_students inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id 
              and user_group_assignments.user_id = #{user.id}
              ) 
             on groups_students.student_id = students.id",
               :conditions => "exists(select id from special_user_groups where (special_user_groups.user_id =#{user.id} and (
               special_user_groups.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT}  or
              (special_user_groups.grouptype=#{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL} and special_user_groups.school_id = enrollments.school_id 
              and ( special_user_groups.grade is null or special_user_groups.grade = enrollments.grade ))))) 
               or groups_students.group_id is not null
               ")
    end


  end

  protected

  def save_extended_profile

   if @extended_profile == ''
       ext_arbitrary.destroy if ext_arbitrary

   end


    
    if @extended_profile.present?
      create_ext_arbitrary(:content =>@extended_profile)
     @extended_profile=nil
    end

  end

  def nullify_blank_district_student_id
    self.district_student_id = nil if district_student_id.blank?
  end

end
