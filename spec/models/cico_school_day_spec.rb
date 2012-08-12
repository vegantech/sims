require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoSchoolDay do
  before(:each) do
    @valid_attributes = {
      :cico_setting => CicoSetting.new,
      :status => 1,
      :date => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    CicoSchoolDay.create!(@valid_attributes)
  end
end
