# == Schema Information
# Schema version: 20090524185436
#
# Table name: consultation_form_requests
#
#  id                          :integer         not null, primary key
#  student_id                  :integer
#  requestor_id                :integer
#  team_id                     :integer
#  all_student_scheduled_staff :boolean
#  created_at                  :datetime
#  updated_at                  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequest do
  before(:each) do
    @valid_attributes = {
      :all_student_scheduled_staff => false
    }
  end

  it "should create a new instance given valid attributes" do
    ConsultationFormRequest.create!(@valid_attributes.merge( :requestor => User.new, :student=>Student.new))
  end
end
