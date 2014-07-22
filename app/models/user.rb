# == Schema Information
# Schema version: 20101101011500
#
# Table name: users
#
#  id               :integer(4)      not null, primary key
#  username         :string(255)
#  passwordhash     :binary
#  first_name       :string(255)
#  last_name        :string(255)
#  district_id      :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#  email            :string(255)
#  middle_name      :string(255)
#  suffix           :string(255)
#  salt             :string(255)     default("")
#  district_user_id :string(255)
#  token            :string(255)
#  roles_mask       :integer(4)      default(0)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :recoverable#, :registerable
#        :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :district_id_for_login
  attr_accessor :district_id_for_login
  include FullName, Devise::LegacyPassword, Pageable, StatsInUse, Stats::User

  belongs_to :district
  has_many :user_school_assignments, :dependent => :destroy
  has_many :special_user_groups, :dependent => :destroy
  has_many :special_schools, :through => :special_user_groups, :source=>:school
  has_many :user_group_assignments, :dependent => :destroy, :inverse_of => :user
  has_many :groups, :through => :user_group_assignments, :order => :title
  has_many :principal_override_requests, :class_name => "PrincipalOverride", :foreign_key => :teacher_id
  has_many :principal_override_responses, :class_name => "PrincipalOverride", :foreign_key => :principal_id
  has_many :student_comments
  has_many :intervention_participants, :dependent => :delete_all
  has_many :interventions_as_participant, :through => :intervention_participants, :class_name => 'Intervention', :source => :intervention
  has_many :school_team_memberships
  has_many :school_teams, :through => :school_team_memberships
  has_many :team_consultations,:foreign_key => :requestor_id
  has_many :personal_groups
  has_many :staff_assignments
  has_many :checklists
  has_many :consultation_forms
  has_many :consultation_form_requests, :foreign_key =>:requestor_id
  has_many :custom_flags
  has_many :ignore_flags
  has_many :intervention_comments
  has_many :intervention_definitions
  has_many :interventions
  has_many :probe_definitions
  has_many :recommendations
  has_many :logs, :class_name => 'DistrictLog'


  attr_protected :district_id

  accepts_nested_attributes_for :staff_assignments, :allow_destroy => true, :reject_if => :duplicate_staff_assignment?
  accepts_nested_attributes_for :user_school_assignments, :allow_destroy => true

#  define_statistic :users_with_content
#  define_statistic :districts_with_users_with_content


  validates_presence_of :username
  validates_presence_of :password, :on => :create, :unless => :blank_password_ok?
#  validates_presence_of :passwordhash, :on => :update, :unless => :blank_password_ok?
  validates_uniqueness_of :username, :scope => :district_id
  validates_confirmation_of :password
  validate :validate_unique_user_school_assignments



  def authorized_groups_for_school(school,grade=nil)
    if all_students_in_school?(school)
      if grade
        school.groups.by_grade(grade)
      else
        school.groups
      end
    else
      if grade
        groups.by_school(school).by_grade(grade)
      else
        groups.by_school(school)
      end
    end
  end

  def cached_authorized_groups_for_school(school, grade=nil)
    @cached_groups_for_school ||= Hash.new
    @cached_groups_for_school[[school.id,grade]] ||= authorized_groups_for_school(school,grade).only_title_and_id
  end

  def filtered_groups_by_school(school,opts={})
    #opts can be grade and prompt and user?
    #default prompt is "*-Filter by Group"
    #the - separates id and prompt
    opts.stringify_keys!
    grade = opts['grade']
    grade = nil if grade == "*"
    grps = cached_authorized_groups_for_school(school,grade)

    if opts["user"].present?
      u_grp_ids = connection.select_values "select group_id from user_group_assignments where user_id = #{opts['user'].to_i}"
      grps = grps.select{ |u_group| u_grp_ids.include? u_group.id}
    end
    personal_groups.by_school_and_grade(school,grade) |grps
  end

  def filtered_members_by_school(school,opts={})
  #opts can be grade, user_id
  #blank grade defaults to *
  #blank user defaults to *
    opts.stringify_keys!
    opts.reverse_merge!( "grade"=>"*")
    grade = opts['grade']
    grade = nil if grade == "*"
    g_ids = cached_authorized_groups_for_school(school,grade).collect(&:id)
    User.find(:all,:select => 'distinct users.*',:joins => :groups ,:conditions=> {:groups=>{:id=>g_ids}}, :order => 'last_name, first_name')
  end

  def authorized_for?(controller)
    !new_record? && Role.has_controller?(controller.to_s,roles)
  end

  def grouped_principal_overrides
    overrides={}
    overrides[:user_requests]=principal_override_requests
    if principal?
      overrides[:principal_responses] = principal_override_responses
      overrides[:pending_requests]=PrincipalOverride.pending_for_principal(self)
    end

    overrides
  end

  def principal?
    !!(user_group_assignments.principal.first || special_user_groups.principal.first)
  end

  def orphaned_interventions_where_principal(school)
    return [] if school.blank?
    Intervention.find_all_by_active(true,:select => "distinct interventions.*",
                                         :joins => "inner join students on interventions.student_id = students.id and students.district_id = #{district_id}
        left outer join special_user_groups on  special_user_groups.user_id = #{self.id} and is_principal=true
        left outer join enrollments on enrollments.student_id = students.id and enrollments.school_id = #{school.id}
        left outer join ( groups_students inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id
          and user_group_assignments.user_id = #{self.id} and user_group_assignments.is_principal=true
          )
         on groups_students.student_id = students.id
        left outer join (intervention_participants ip  inner join users iu  on ip.user_id = iu.id ) on
        ip.intervention_id = interventions.id

        ",
                                         :conditions => "(interventions.end_date < '#{Date.today}' or iu.id is null or iu.district_id != students.district_id
           or not exists (  select 2 from special_user_groups sug where sug.user_id = iu.id and  ((iu.all_students = 1 )
           or ( sug.school_id = enrollments.school_id
           and ( sug.grade is null or sug.grade = enrollments.grade ) ))
           union select 2 from groups_students gs inner join user_group_assignments uga on gs.group_id =uga.group_id where gs.student_id = students.id and uga.user_id = iu.id
           )

           ) and ((iu.all_students = 1 ) or
          (special_user_groups.school_id = enrollments.school_id
          and ( special_user_groups.grade is null or special_user_groups.grade = enrollments.grade )
          ) or user_group_assignments.id is not null)
    ")#.select(&:orphaned?)


  end

 def self.remove_from_district(user_ids = [])
    user_ids = Array(user_ids).flatten.collect(&:to_i)
    return nil if user_ids.blank?
    User.connection.update("update users set username = concat(district_id,'-',username,'-',#{Time.now.usec}), roles_mask=0, passwordhash='disabled',district_id=NULL,email=NULL,encrypted_password='' where id in (#{user_ids.join(",")})")
    UserSchoolAssignment.delete_all(["user_id in (?)",user_ids])
    SpecialUserGroup.delete_all(["user_id in (?)",user_ids])
    UserGroupAssignment.delete_all(["user_id in (?)",user_ids])
    StaffAssignment.delete_all(["user_id in (?)",user_ids])
    SchoolTeamMembership.delete_all(["user_id in (?)",user_ids])
  end
  def remove_from_district
    User.remove_from_district(self[:id])
  end

  def roles=(roles)
    @roles = nil
    self.roles_mask = Role.roles_to_mask(roles)
  end


  def roles
    @roles ||= Role.mask_to_roles(roles_mask)
  end

  def role?(role)
    roles.include?(role.to_s)
  end

  def self.find_all_by_role(role,options = {})
    with_scope :find => options do
      find(:all,:conditions => ["roles_mask & ? ",1 << Role::ROLES.index(role)]) unless Role::ROLES.index(role).nil?
    end
  end

  def last_login
    @last_login ||=logs.success.order("updated_at desc").first.try(:updated_at)
  end

  def all_students_in_school?(school)
    all_students? || special_user_groups.all_students_in_school?(school)
  end

  def admin_of_school?(school)
    user_school_assignments.admin.exists?(:school_id => school.id)
  end

   def schools
    s=School.where(:district_id => district_id).order("schools.name")
    if all_schools_in_district?
      s
    else
      s.where("schools.id in (#{user_school_assignments.school_id.to_sql})
        or
        schools.id in (#{special_user_groups.school_id.to_sql})")
    end
  end

  def all_schools_in_district?
    all_students? || all_schools?
  end

  def students_for_school(school)
    s=Student.includes(:enrollments).where(:enrollments=>{:school_id => school}, :district_id=> district_id)
    if all_students?
      s
    else
      s.where("students.id in (#{special_user_groups.for_school(school).student_id.to_sql}) or
              students.id in (#{user_group_assignments.student_id_for_school(school).to_sql})
              ")
    end
  end

  def self.find_first_by_auth_conditions(conditions)
    conditions[:district_id] = conditions.delete(:district_id_for_login) unless conditions.keys == [:reset_password_token]
    super conditions
  end

  def self.find_for_googleapps_oauth(access_token, _signed_in_resource=nil)
    data = access_token['info']

    if user = User.where(:email => data['email']).first
      return user
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
        user.email = data['email']
      end
    end
  end

  def send_reset_password_instructions(use_key = false)
    if email.blank?
      errors.add(:base, 'User does not have email assigned in SIMS.  Contact your LSA for assistance')
    elsif !use_key && !district.try(:forgot_password)
      errors.add(:base, "This district does not support password recovery.  Contact your LSA for assistance")
    else
      super()
    end
  end

  def custom_interventions_enabled?
    district.custom_interventions.blank? ||
      district.custom_interventions == "only_author" ||
      district.custom_interventions == "one_off" ||
      (district.custom_interventions == 'content_admins' && roles.include?('content_admin') )
  end

  protected

  def student_ids_where_principal(school_id)
    #TODO TEST THIS
    ##User.connection.select_values(User.find(10).send( :student_ids_where_principal,School.last.id))
 Student.send(:construct_finder_sql, :select => "students.id",
                                     :joins =>
"left outer join special_user_groups on  special_user_groups.user_id = #{self.id}
         left outer join enrollments on enrollments.student_id = students.id
         left outer join ( groups_students inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id
           and user_group_assignments.user_id = #{self.id})
          on groups_students.student_id = students.id",
                                     :conditions => "students.district_id = #{self.district_id} and enrollments.school_id = #{school_id}")



  end

  def blank_password_ok?
    email.present? && district && district.key.present?
  end

  def validate_unique_user_school_assignments
    validate_uniqueness_of_in_memory(
      user_school_assignments, [:school_id, :admin], 'Duplicate User.')
  end

  def duplicate_staff_assignment?(attributes)
     staff_assignments.reject(&:marked_for_destruction?).collect(&:school_id).include?(attributes[:school_id])
  end

  def duplicate_user_school_assignment?(attributes)
     staff_assignments.reject(&:marked_for_destruction?).collect{|r| [r.school_id, r.admin]}.include?([attributes[:school_id], attributes[:admin]])
  end
end
