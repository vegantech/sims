# == Schema Information
# Schema version: 20081205205925
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

  named_scope :by_school, lambda { |school| {:conditions=>{:school_id=>school}}}
  def self.members
    #TODO tested, but it is ugly and should be refactored
    find(:all).collect(&:users).flatten.compact.uniq
  end

  def principals
   users.find(:all, :include=>:user_group_assignments, :conditions => ["user_group_assignments.is_principal = ?",true])

    
  end

end
