# == Schema Information
# Schema version: 20081030035908
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  school_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Group < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :students
  has_many :user_group_assignments
  has_many :users, :through=>:user_group_assignments

  #named_scope :by_school, lambda { |school| {:conditions=>{:school_id=>school}}}
  def self.members_for_school(school, grade=nil)
    #placeholder
    find_all_by_school_id(school.id).collect(&:users).flatten.compact.uniq

    
    #find(:all,:conditions=>{:school=>school}.collect(&:users)
  end

end
