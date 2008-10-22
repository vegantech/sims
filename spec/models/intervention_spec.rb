require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Intervention do
  before(:each) do
    @valid_attributes = {
      :start_date => Date.today,
      :end_date => Date.today,
      :frequency_id =>1 ,
      :frequency_multiplier => "1",
      :time_length_id => 1 ,
      :time_length_number => "1",
      :active => false,
      :ended_at => Date.today,
    }
  end

  it "should create a new instance given valid attributes" do
    Intervention.create!(@valid_attributes)
  end
end
