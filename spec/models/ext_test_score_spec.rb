require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtTestScore do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :date => Date.today,
      :scaleScore => 1.5,
      :result => "value for result",
      :enddate => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    ExtTestScore.create!(@valid_attributes)
  end
end
