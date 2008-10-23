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
      :active => true,
    }
  end

  it "should create a new instance given valid attributes" do
    Intervention.create!(@valid_attributes)
  end

  it "should end an intervention" do
    i=Intervention.create!(@valid_attributes)
    i=Intervention.find(:first)
    i.end(1)
    i.reload
    i.active.should ==(false)
    i.ended_by_id.should ==(1)
    i.ended_at.should == Date.today

  end

end
