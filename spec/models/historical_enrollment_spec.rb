require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HistoricalEnrollment do
  before(:each) do
    @valid_attributes = {
      :student => Student.new,
      :district => District.new,
      :school => School.new,
      :start_date => Date.today,
      :end_date => Date.today,
      :end_year => 1
    }
  end

  it "should create a new instance given valid attributes" do
#    HistoricalEnrollment.create!(@valid_attributes)
  end
end
