class UserSchoolAssignment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user
  validates_presence_of :school_id,:user_id

  named_scope :admin, :conditions=>{:admin=>true}
end
