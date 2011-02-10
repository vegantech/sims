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

  
  
  include FullName
  after_update :save_user_school_assignments

  belongs_to :district
  has_many :user_school_assignments, :dependent => :destroy
  has_many :schools, :through => :user_school_assignments, :order => "name"
  has_many :special_user_groups, :dependent => :destroy
  has_many :special_schools, :through => :special_user_groups, :source=>:school
  has_many :user_group_assignments, :dependent => :destroy
  has_many :groups, :through => :user_group_assignments, :order => :title
  has_many :principal_override_requests, :class_name => "PrincipalOverride", :foreign_key => :teacher_id
  has_many :principal_override_responses, :class_name => "PrincipalOverride", :foreign_key => :principal_id
  has_many :student_comments
  has_many :intervention_participants, :dependent => :delete_all
  has_many :interventions_as_participant, :through => :intervention_participants, :class_name => 'Intervention', :source => :intervention
  has_many :school_team_memberships
  has_many :school_teams, :through => :school_team_memberships
  has_many :team_consultations,:foreign_key => :requestor_id
  has_many :staff_assignments
  has_many :checklists
  has_many :consultation_forms
  has_many :consultation_form_requests
  has_many :custom_flags
  has_many :ignore_flags
  has_many :intervention_comments
  has_many :intervention_definitions
  has_many :interventions
  has_many :probe_definitions
  has_many :recommendations


  attr_accessor :password, :all_students_in_district, :old_password

  define_statistic :user_accounts, :count => :all, :conditions => "username != 'district_admin'"
  

  validates_presence_of :username, :last_name, :first_name
  validates_presence_of :password, :on => :create, :unless => :blank_password_ok?
  validates_presence_of :passwordhash, :on => :update, :unless => :blank_password_ok?
  validates_uniqueness_of :username, :scope => :district_id
  validates_confirmation_of :password

  before_save :nullify_blank_district_user_id
  after_save :district_special_groups

  acts_as_reportable # if defined? Ruport

  def authorized_groups_for_school(school,grade=nil)
    if special_user_groups.all_students_in_school?(school)
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

  def filtered_groups_by_school(school,opts={})
    #opts can be grade and prompt
    #default prompt is "*-Filter by Group"
    #the - separates id and prompt
    
    opts.stringify_keys!
    
    grade = opts[:grade]
    grade = nil if grade == "*"
    prompt_id,prompt_text=(opts["prompt"] || "*-Filter by Group").split("-",2)
    grps = authorized_groups_for_school(school,grade)

    unless opts["user"].blank?
      grps = grps.select do |u_group|
        u_group.users.exists?(opts["user"].to_i)
      end
    end
    
    if grps.length > 1 or special_user_groups.all_students_in_school?(school)
      grps.unshift(Group.new(:id=>prompt_id,:title=>prompt_text))
    end

    @groups=grps

  end

  def self.paged_by_last_name(last_name="", page="1")
    paginate :per_page => 25, :page => page, 
      :conditions=> ['last_name like ?', "%#{last_name}%"],
      :order => 'last_name'
  end


  
  def filtered_members_by_school(school,opts={})
  #opts can be grade, user_id and prompt
  #default prompt is "*-Filter by Group Member"
  #the - separates id and prompt
  #blank grade defaults to *
  #blank user defaults to *

    opts.stringify_keys!
    opts.reverse_merge!( "grade"=>"*")

    grade = opts[:grade]
    grade = nil if grade == "*"
    users=authorized_groups_for_school(school,grade).members
    unless opts["grade"]  == "*"
#      user_ids =users.collect(&:id)
 #     users=User.find(:all, :joins => {:groups=>{:students => :enrollments}}, :conditions => {:id=>user_ids, :groups=>{:school_id => school}, :enrollments =>{:grade => opts["grade"]}}, :order => 'last_name, first_name').uniq
    end
    #    users=users.sort_by{|u| u.to_s}
    prompt_id,prompt_text=(opts["prompt"] || "*-All Staff").split("-",2)
    prompt_first,prompt_last=prompt_text.split(" ",2)
    users.unshift(User.new(:id=>prompt_id,:first_name=>prompt_first, :last_name=>prompt_last)) if users.size > 1 or special_user_groups.all_students_in_school?(school)

    users
  end

   
  def authorized_schools(school_id=nil)
    c_hash = {}
    c_hash[:conditions] = {:id=>school_id} unless school_id.blank?
    #TODO make all students in school implicit
    if special_user_groups.all_schools_in_district.find_by_district_id(self.district_id)
      district.schools.find(:all,c_hash)
    else
      sc_hash = {}
      sc_hash[:conditions] = {:school_id => school_id} unless school_id.blank?
      schools.find(:all,c_hash) | special_user_groups.find(:all,sc_hash).collect(&:school).compact.flatten
    end
  end

  def self.authenticate(username, password)
    @user = self.find_by_username(username)

    if @user && @user.passwordhash.blank? && @user.salt.blank?
      if @user.district.key.present? && @user.district.key == password
        @user.update_attribute(:token, Digest::SHA1.hexdigest("#{@user.district.key}#{rand}#{@user.id}"))
        Notifications.deliver_change_password(@user)
        #send the email
        @user = User.new(:token => @user.token)
        
        return @user
      else
        @user = nil
      end


    end

    if @user
      unless(@user.allowed_password_hashes(password).include?(@user.passwordhash_before_type_cast.downcase[0..39]))
         @user = nil unless ENV["RAILS_ENV"] =="development" || ENV["SKIP_PASSWORD"]=="skip-password"
      end
      @user
    end
  end

  def allowed_password_hashes(password)
    district_key = district.key if district
    next_key = self.district.previous_key if self.district
    
    bare = User.encrypted_password(password,salt, nil, nil)
    with_sys_key_and_no_district_key = User.encrypted_password(password,salt, nil)

    with_district_key_and_no_system_key = User.encrypted_password(password, salt, district_key, nil)
    with_district_key_and_system_key = User.encrypted_password(password, salt, district_key)

    with_next_district_key_and_no_system_key = User.encrypted_password(password, salt,  next_key, nil)
    with_next_district_key_and_system_key = User.encrypted_password(password, salt, next_key, System::HASH_KEY)

    [bare, with_sys_key_and_no_district_key, with_district_key_and_no_system_key, with_district_key_and_system_key,
      with_next_district_key_and_no_system_key,  with_next_district_key_and_system_key ]
  end

  def self.encrypted_password(password, salt=nil, district_key = nil, system_hash = System::HASH_KEY)
    Digest::SHA1.hexdigest("#{system_hash}#{password.downcase}#{district_key}#{salt}")
  end
  
  
  def authorized_for?(controller, action_group)
    !new_record? && Role.has_controller_and_action_group?(controller.to_s, action_group.to_s,roles)
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

  def password=(pass)
    if pass.blank?
      @password_confirmation=@password=pass
    else
      @password = pass
      puts "district is #{pp district}" if @password == 'motest'
      self.salt = [Array.new(8){rand(256).chr}.join].pack("m").chomp unless salt_changed?
      set_passwordhash pass
    end
  end

  def set_passwordhash(pass)
    district_key = self.district.key if self.district
    self.passwordhash = User.encrypted_password(pass, self.salt, district_key)
  end

  def reset_password!
    update_attribute(:passwordhash,User.encrypted_password("district_admin"))
    "Password reset to district_admin"
  end

  def principal?
    !!(user_group_assignments.principal.first || special_user_groups.principal.first)
  end

  def orphaned_interventions_where_principal(school)
    return [] if school.blank?
    Intervention.find_all_by_active(true,:select => "distinct interventions.*",
                                    :joins => "inner join students on interventions.student_id = students.id and students.district_id = #{district_id}
        left outer join special_user_groups on  special_user_groups.user_id = #{self.id} and is_principal=true   and special_user_groups.district_id = #{self.district_id}
        left outer join enrollments on enrollments.student_id = students.id and enrollments.school_id = #{school.id}
        left outer join ( groups_students inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id 
          and user_group_assignments.user_id = #{self.id} and user_group_assignments.is_principal=true
          ) 
         on groups_students.student_id = students.id
        left outer join (intervention_participants ip  inner join users iu  on ip.user_id = iu.id ) on
        ip.intervention_id = interventions.id 
        
        ",
           :conditions => "(interventions.end_date < '#{Date.today}' or iu.id is null or iu.district_id != students.district_id
           or not exists (  select 2 from special_user_groups sug where sug.user_id = iu.id and  (( sug.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT}  ) 
           or (sug.grouptype=#{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL} and sug.school_id = enrollments.school_id 
           and ( sug.grade is null or sug.grade = enrollments.grade ) )
           ) 
           union select 2 from groups_students gs inner join user_group_assignments uga on gs.group_id =uga.group_id where gs.student_id = students.id and uga.user_id = iu.id
           
           
           ) 
           
           ) and ((special_user_groups.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT} ) or
          (special_user_groups.grouptype=#{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL} and special_user_groups.school_id = enrollments.school_id 
          and ( special_user_groups.grade is null or special_user_groups.grade = enrollments.grade ) 
          ) or user_group_assignments.id is not null)
    ")#.select(&:orphaned?)


  end

  def all_students_in_district
    #called in district/users/_district_groups.html.erb
    special_user_groups.all_students_in_district.find_by_district_id(self.district_id)

  end

  def self.paged_by_last_name(last_name="", page="1")
    paginate :per_page => 25, :page => page, 
      :conditions=> ['last_name like ?', "%#{last_name}%"],
      :order => 'last_name'
  end

  def existing_user_school_assignment_attributes=(user_school_assignment_attributes)
    user_school_assignments.reject(&:new_record?).each do |user_school_assignment|
      attributes = user_school_assignment_attributes[user_school_assignment.id.to_s]

      if attributes
        user_school_assignment.attributes = attributes
      else
        user_school_assignments.delete(user_school_assignment)
      end
    end
  end

  def new_user_school_assignment_attributes=(usa_attributes)
    usa_attributes.each do |attributes|
      user_school_assignments.build(attributes)
    end
  end

  def self.remove_from_district(user_ids = [])
    user_ids = Array(user_ids).flatten.collect(&:to_i)
    return nil if user_ids.blank?
    User.connection.update("update users set username = concat(district_id,'-',username,'-',#{Time.now.usec}), roles_mask=0, passwordhash='disabled',district_id=NULL,email=NULL where id in (#{user_ids.join(",")})")
    UserSchoolAssignment.delete_all(["user_id in (?)",user_ids])
    SpecialUserGroup.delete_all(["user_id in (?)",user_ids])
    UserGroupAssignment.delete_all(["user_id in (?)",user_ids])
    StaffAssignment.delete_all(["user_id in (?)",user_ids])
    SchoolTeamMembership.delete_all(["user_id in (?)",user_ids])
  end
  def remove_from_district
    User.remove_from_district(self[:id])
  end

  def change_password(params)
    if self.passwordhash.blank? && self.salt.blank? 
      errors.add(:old_password, "is incorrect") and return false  if (!self.district.key.present? || self.district.key != params[:old_password])

      errors.add(:password, 'cannot be blank') and return false if params['password'].blank?
      errors.add(:password_confirmation, 'must match password') and return false if params['password'] != params['password_confirmation']

      self.password = params['password']
      self.password_confirmation = params['password_confirmation']
      return false if self.token != params['token']
      self.token = nil
      self.save 
      return true
    end

    if !self.district.users.authenticate(self.username, params['old_password'])
      errors.add(:old_password, "is incorrect") 
    elsif params['password'].blank?
      errors.add(:password, 'cannot be blank')
    elsif params['password'] != params['password_confirmation']
      errors.add(:password_confirmation, 'must match password')
    else
      self.password = params['password']
      self.password_confirmation = params['password_confirmation']
      self.save
      return true
    end

    false

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
      find(:all,:conditions => ["roles_mask & ? ",2**Role::ROLES.index(role)]) unless Role::ROLES.index(role).nil?
    end
  end
=begin

                    left outer join  user_group_assignments on user_group_assignments.user_id = #{self.id} 
                    inner join groups_students on groups_students.group_id = user_group_assignments.group_id 
                    and groups_students.student_id = students.id 




 and 
special_user_groups.user_id = #{self.id} and special_user_groups.district_id = #{self.district_id})
or (special_user_groups.grouptype=#{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL} and special_user_groups.school_id = enrollments.school_id
and (special_user_groups.grade is null or special_user_groups.grade = enrollments.grade))
or (user_group_assignments.id is not null) 

=end

  def authorized_students(num=:all)
    district.students.find(num,
        :joins => "left outer join special_user_groups on  special_user_groups.user_id = #{self.id}   and special_user_groups.district_id = #{self.district_id}
        left outer join enrollments on enrollments.student_id = students.id
        left outer join ( groups_students inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id 
          and user_group_assignments.user_id = #{self.id}
          ) 
         on groups_students.student_id = students.id",
        :conditions => "(special_user_groups.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT} ) or
          (special_user_groups.grouptype=#{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL} and special_user_groups.school_id = enrollments.school_id 
          and ( special_user_groups.grade is null or special_user_groups.grade = enrollments.grade ) 
          ) or user_group_assignments.id is not null
    ")
  end

  def last_login
    @last_login ||=district.logs.find_by_body("Successful Login of #{fullname}", :order => "updated_at desc").try(:updated_at)
  end

protected

  def student_ids_where_principal(school_id)
    #TODO TEST THIS
    ##User.connection.select_values(User.find(10).send( :student_ids_where_principal,School.last.id))
 Student.send(:construct_finder_sql, :select => "students.id", 
                  :joins => 
"left outer join special_user_groups on  special_user_groups.user_id = #{self.id}   and special_user_groups.district_id = #{self.district_id}
         left outer join enrollments on enrollments.student_id = students.id
         left outer join ( groups_students inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id 
           and user_group_assignments.user_id = #{self.id}) 
          on groups_students.student_id = students.id",
                  :conditions => "students.district_id = #{self.district_id} and enrollments.school_id = #{school_id}")



  end



  def district_special_groups

    if @all_students_in_district == "1"
      special_user_groups.find_or_create_by_district_id_and_grouptype(self.district_id,SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT)
    elsif @all_students_in_district == "0" or new_record?
      special_user_groups.find_by_district_id_and_grouptype(self.district_id,SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT).try(:destroy)
    end
    
  end

  def save_user_school_assignments
    user_school_assignments.each do |user_school_assignment|
      user_school_assignment.save(false)
    end
  end

  def nullify_blank_district_user_id
    self.district_user_id = nil if district_user_id.blank?
  end

  def blank_password_ok?
    email.present? && district && district.key.present?
  end
end
