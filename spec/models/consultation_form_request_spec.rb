require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequest do
  before(:each) do
    @valid_attributes = {
      :all_student_scheduled_staff => false
    }
  end

  it "should create a new instance given valid attributes" do
    ConsultationFormRequest.create!(@valid_attributes)
  end
end
