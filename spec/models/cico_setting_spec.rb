require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoSetting do
  before(:each) do
    @valid_attributes = {
      :school => ,
      :probe_definition => ,
      :enabled => false,
      :default_participant => ,
      :points_per_expectation => 1,
      :default_goal => 1,
      :days_to_collect => 
    }
  end

  it "should create a new instance given valid attributes" do
    CicoSetting.create!(@valid_attributes)
  end
end
