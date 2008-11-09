# == Schema Information
# Schema version: 20081030035908
#
# Table name: users
#
#  id           :integer         not null, primary key
#  username     :string(255)
#  passwordhash :binary
#  first_name   :string(255)
#  last_name    :string(255)
#  district_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class User < ActiveRecord::Base
  belongs_to :district
  has_and_belongs_to_many :schools
  has_many :special_user_groups
  has_many :special_schools, :through => :special_user_groups, :source=>:school
  has_many :user_group_assignments
  has_many :groups, :through=> :user_group_assignments

  validates_presence_of :username, :passwordhash, :last_name, :first_name
  validates_uniqueness_of :username, :scope=>:district_id

  def authorized_groups_for_school(school)
    if special_user_groups.all_students_in_school?(school)
      school.groups
    else
      groups
    end
  end

  def filtered_groups_by_school(school,opts={})
  #opts can be grade and prompt
  #default prompt is "*-Filter by Group"
  #the - separates id and prompt
   
    opts.symbolize_keys!.reverse_merge!(:prompt=>"*-Filter by Group",
                        :grade=>"*"
                        )

    grps=authorized_groups_for_school(school)

    unless opts[:grade] =="*"
      grps = grps.select do |u_group|
        u_group.students.exist?(:conditions=>["enrollments.grade=?",opts[:grade]],:include=>:enrollments)
      end
    end

    unless opts[:user].blank?
      grps = grps.select do |u_group|
        u_group.users.exists?(opts[:user].to_i)
      end
    end

    
    prompt_id,prompt_text=opts[:prompt].split("-",2)
    grps.unshift(Group.new(:id=>prompt_id,:title=>prompt_text)) if grps.size > 1 or special_user_groups.all_students_in_school?(school)
    @groups=grps

  end

  def filtered_members_by_school(school,opts={})
  #opts can be grade, user_id and prompt
  #default prompt is "*-Filter by Group"
  #the - separates id and prompt
  #blank grade defaults to *
  #blank user defaults to *

    opts.symbolize_keys!.reverse_merge!(:prompt=>"*-Filter by Group Member",
                        :grade=>"*")

    users=authorized_groups_for_school(school).members
    unless opts[:grade]  == "*"
      users=users.select do |group_user|
        group_user.groups.any? do |u_group|
          u_group.students.exist?(:conditions=>["enrollments.grade=?",opts[:grade]],:include=>:enrollments)
        end
      end
    end

    
    prompt_id,prompt_text=opts[:prompt].split("-",2)
    prompt_first,prompt_last=prompt_text.split(" ",2)
    users.unshift(User.new(:id=>prompt_id,:first_name=>prompt_first, :last_name=>prompt_last)) if users.size > 1 or special_user_groups.all_students_in_school?(school)

    users
  end


  def authorized_enrollments_for_school(school)
    if special_user_groups.all_students_in_school?(school)
      school.enrollments
   else
      grades=special_user_groups.grades_for_school(school)
      student_ids = groups.find_all_by_school_id(school).collect(&:student_ids).flatten.uniq
      school.enrollments.by_student_ids_or_grades(student_ids,grades)
    end

  end

  def authorized_schools(school_id=nil)
    if school_id
      schools.find_by_id(school_id) || 
        special_schools.find_by_id(school_id) ||
        (special_user_groups_all_schools_in_district.find_by_district_id(self.district_id) && district.schools.find_by_id(school_id))
    else

    #TODO make all students in school implicit
      if special_user_groups.all_schools_in_district.find_by_district_id(self.district_id)
        district.schools
      else
        schools | special_user_groups.schools
      end
    end
  end

  def self.authenticate(username, password)
		@user = self.find_by_username(username)
       
		if @user
			expected_password=encrypted_password(password)
			if @user.passwordhash != expected_password
         @user = nil unless ENV["RAILS_ENV"] =="development" || ENV["SKIP_PASSWORD"]=="skip-password"
			end
			@user
		end
	end

	def self.encrypted_password(password)
		Digest::SHA1.hexdigest(password.downcase)
	end

   
	def fullname 
		first_name.to_s + ' ' + last_name.to_s
  end

	def fullname_last_first
		last_name.to_s + ', ' + first_name.to_s
	end

  def has_group_for_school? school
   !!( special_schools.find_by_id(school.id) ||  groups.find_by_school_id(school.id) )
  end
end
