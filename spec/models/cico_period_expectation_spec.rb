require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoPeriodExpectation do
  before(:each) do
    @valid_attributes = {
      :cico_student_day => ,
      :cico_period => ,
      :cico_expectation => ,
      :score => 1,
      :status => "value for status"
    }
  end

  it "should create a new instance given valid attributes" do
    CicoPeriodExpectation.create!(@valid_attributes)
  end
end
