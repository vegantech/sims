# == Schema Information
# Schema version: 20101101011500
#
# Table name: students
#
#  id                  :integer(4)      not null, primary key
#  district_id         :integer(4)
#  last_name           :string(255)
#  first_name          :string(255)
#  number              :string(255)
#  district_student_id :string(255)
#  id_state            :integer(4)
#  id_country          :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  birthdate           :date
#  esl                 :boolean(1)
#  special_ed          :boolean(1)
#  middle_name         :string(255)
#  suffix              :string(255)
#

class Student < ActiveRecord::Base

  include FullName, Pageable, LighterTouch, StatsInUse,Stats::Student
  include LinkAndAttachmentAssets

  CUSTOM_CONTENT = %w{ custom_flags comments team_consultations interventions checklists recommendations principal_overrides consultation_forms consultation_form_requests ignore_flags }

  belongs_to :district
  has_and_belongs_to_many :groups
  has_many :checklists, :dependent => :destroy
  has_many :recommendations, :dependent => :destroy
  has_many :enrollments, :dependent => :destroy
  has_many :schools, :through => :enrollments
  has_many :comments, :dependent => :delete_all ,  :class_name => "StudentComment", :order => 'created_at desc'
  has_many :principal_overrides, :dependent => :delete_all
  has_many :interventions, :dependent => :delete_all
  has_many :system_flags
  has_many :custom_flags
  has_many :ignore_flags
  has_many :flags, :dependent => :delete_all
  has_many :team_consultations, :dependent => :destroy
  has_many :team_consultations_pending, :conditions => {:complete => false, :draft => false}, :class_name => "TeamConsultation"
  has_many :consultation_form_requests, :dependent => :destroy
  has_many :consultation_forms
  has_one :ext_arbitrary, :dependent => :delete
  has_many :ext_siblings,:dependent => :delete_all
  has_many :ext_adult_contacts, :order => "guardian desc", :dependent => :delete_all
  has_many :ext_test_scores, :order => "date", :dependent => :delete_all
  has_one :ext_summary, :dependent => :delete
  has_and_belongs_to_many :personal_groups
  attr_protected :district_id
  accepts_nested_attributes_for :enrollments, :allow_destroy => true
  accepts_nested_attributes_for :system_flags, :allow_destroy => true



  scope :by_state_id_and_id_state, lambda { |state_id, id_state|
    joins(:district).where({:districts=>{:state_id => state_id}, :id_state => id_state}).limit(1)}






  validates_presence_of :district_id
  validates_uniqueness_of :district_student_id, :scope => :district_id, :allow_blank => true
  validate :unique_id_state

  delegate :recommendation_definition, :to => '(checklist_definition or return nil)'

  after_save :save_extended_profile
  #  before_validation :clear_extended_profile



  def extended_profile?
    ext_arbitrary.present? || ext_siblings.present? || ext_adult_contacts.present? || ext_test_scores.present? || ext_summary.present? || assets.present?
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


  def has_content?
    CUSTOM_CONTENT.any?{|c| self.send(c).any?}
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

  def special_group_principals
    grades = enrollments.collect(&:grade)
    schools = enrollments.collect(&:school).compact
    principals = []

    schools.each do |school|
      principals << school.special_user_groups.principal.where(["grade in (?) or grade is null",grades]).collect(&:user)
    end

    principals
  end

  def belongs_to_user?(user)
    user.district_id == district_id &&
   (user.all_students? || user.groups.find_by_id(group_ids) ||
      user.special_user_groups.find_by_school_id(school_ids) )
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

  def all_staff_for_student
    (groups.collect(&:users) | special_group_principals).flatten.compact.uniq
  end

  def remove_from_district
    #TODO delete the student if they aren't in use anymore
    enrollments.destroy_all
    groups.clear
    update_attribute(:district_id,nil)
  end

  def unique_id_state
    if id_state.present?
      other_student = Student.find_by_id_state(id_state, :conditions => ["district_id != ?",self.district_id])
      if other_student
        errors.add(:id_state, "Student with #{self.id_state} already exists in #{other_student.district}")
      end
    end
  end

  def pending_consultation_forms
    ConsultationForm.all(:joins => :team_consultation, :conditions => {:team_consultations => {:complete => false, :student_id => self.id, :draft => false}})
  end

  def safe_destroy
    destroy unless reload.has_content?
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
end
