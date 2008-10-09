require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentComment do
  before(:each) do
    @valid_attributes = {
      :student => ,
      :user => ,
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    StudentComment.create!(@valid_attributes)
  end
end
