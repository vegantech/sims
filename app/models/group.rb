# == Schema Information
# Schema version: 20090623023153
#
# Table name: groups
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  school_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  id_district :string(255)
#

class Group < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :students
  has_many :user_group_assignments
  has_many :users, :through=>:user_group_assignments
  validates_presence_of :title, :school_id
  validates_uniqueness_of :title, :scope=>:school_id

  named_scope :by_school, lambda { |school| {:conditions=>{:school_id=>school}}}
  def self.members
    #TODO tested, but it is ugly and should be refactored
    group_ids=find(:all,:select=>"groups.id")
    User.find(:all,:joins => :groups ,:conditions=> {:groups=>{:id=>group_ids}}, :order => 'last_name, first_name').uniq
  end

  def principals
   users.find(:all, :include=>:user_group_assignments, :conditions => ["user_group_assignments.is_principal = ?",true])
  end

  def self.paged_by_title(title="", page="1")
    paginate :per_page => 25, :page => page, 
      :conditions=> ['title like ?', "%#{title}%"],
      :order => 'title'
  end


  def self.authorized_for_user(user,num=:all, options = {})
    with_scope :find => options do
      find(num,
          :joins => "
          inner join groups_students on groups.id = groups_students.group_id
          inner join enrollments on enrollments.student_id = groups_students.student_id
          left outer join user_group_assignments on groups.id = user_group_assignments.group_id 
            and user_group_assignments.user_id = #{user.id} ",
          :conditions => "exists(select id from special_user_groups where (special_user_groups.user_id =#{user.id} and (
               special_user_groups.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT}  or
              (special_user_groups.grouptype=#{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL} and special_user_groups.school_id = enrollments.school_id 
              and ( special_user_groups.grade is null or special_user_groups.grade = enrollments.grade ))))) 
               or groups_students.group_id is not null
               ")
    end


  end


end
