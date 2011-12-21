# == Schema Information
# Schema version: 20101101011500
#
# Table name: staff_assignments
#
#  id        :integer(4)      not null, primary key
#  school_id :integer(4)
#  user_id   :integer(4)
#

class StaffAssignment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user
  before_create :skip_create_if_duplicate

  private
  def skip_create_if_duplicate
    #skip the save, but preserve the callback chain so the other nested attributes get saved
    #change in rails from 2.3.4 to 2.3.14 (perhaps in .8)
    #TODO look into this when upgrading
    @skip_create =  StaffAssignment.find_by_user_id_and_school_id(user_id, school_id)
    true
  end

  def create_without_callbacks(*args)
     @skip_create || super
  end
end
