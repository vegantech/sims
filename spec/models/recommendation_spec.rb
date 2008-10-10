require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recommendation do
  before(:each) do
    @valid_attributes = {
      :progress => "1",
      :recommendation => "1",
      :reason => "value for reason",
      :should_advance => false
    }
  end

  it "should create a new instance given valid attributes" do
    pending 'No unit test either, need to test this in isolation from checklist'
    Recommendation.create!(@valid_attributes)
  end
end
