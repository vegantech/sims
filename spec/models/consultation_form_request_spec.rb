# == Schema Information
# Schema version: 20101027022939
#
# Table name: consultation_form_requests
#
#  id                          :integer(4)      not null, primary key
#  student_id                  :integer(4)
#  requestor_id                :integer(4)
#  team_id                     :integer(4)
#  all_student_scheduled_staff :boolean(1)
#  created_at                  :datetime
#  updated_at                  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequest do
  before(:each) do
    @valid_attributes = {
      :all_student_scheduled_staff => false,
      
    }
  end

  it "should create a new instance given valid attributes" do
    pending
    ConsultationFormRequest.create!(@valid_attributes.merge( :requestor => User.new, :student=>Student.new))
  end
end
