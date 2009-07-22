require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagDescription do
  before(:each) do
    @valid_attributes = {
      :district_id => 1,
      :languagearts => "value for languagearts",
      :math => "value for math",
      :suspension => "value for suspension",
      :attendance => "value for attendance"
    }
  end

  it "should create a new instance given valid attributes" do
    FlagDescription.create!(@valid_attributes)
  end
end
