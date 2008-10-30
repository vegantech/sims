class Group < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :students
  has_many :user_group_assignments
  has_many :users, :through=>:user_group_assignments

  #named_scope :by_school, lambda { |school| {:conditions=>{:school_id=>school}}}

end
