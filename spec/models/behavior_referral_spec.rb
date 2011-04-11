require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BehaviorReferral do
  before(:each) do
    @valid_attributes = {
      :school => ,
      :student => ,
      :end_year => 1,
      :recorder_id => 1,
      :reported_by => 1,
      :motivation => 1,
      :behavior => 1,
      :admin_decision => 1,
      :half_days_of_suspension => 1,
      :time => Time.now,
      :location => 1,
      :other => "value for other"
    }
  end

  it "should create a new instance given valid attributes" do
    BehaviorReferral.create!(@valid_attributes)
  end
end
