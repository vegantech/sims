require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormConcern do
  before(:each) do
    @valid_attributes = {
      :area => 1,
      :checked => false,
      :strengths => "value for strengths",
      :concerns => "value for concerns",
      :recent_changes => "value for recent_changes"
    }
  end

  it "should create a new instance given valid attributes" do
    ConsultationFormConcern.create!(@valid_attributes)
  end
end
