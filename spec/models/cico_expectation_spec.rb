require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoExpectation do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :position => 1,
      :cico_setting => CicoSetting.new
    }
  end

  it "should create a new instance given valid attributes" do
    CicoExpectation.create!(@valid_attributes)
  end
end
