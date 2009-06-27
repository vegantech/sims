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
    User.find(:all,:joins => :groups ,:conditions=> {:groups=>{:id=>group_ids}}).uniq
  end

  def principals
   users.find(:all, :include=>:user_group_assignments, :conditions => ["user_group_assignments.is_principal = ?",true])
  end

  def self.paged_by_title(title="", page="1")
    paginate :per_page => 25, :page => page, 
      :conditions=> ['title like ?', "%#{title}%"],
      :order => 'title'
  end
end
