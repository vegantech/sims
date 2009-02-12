# == Schema Information
# Schema version: 20090212222347
#
# Table name: rights
#
#  id           :integer         not null, primary key
#  controller   :string(255)
#  read_access  :boolean
#  write_access :boolean
#  role_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


unless defined? AllControllers
  class AllControllers
    NAMES=['students']
  end
end

describe Right do
  before(:each) do
    @valid_attributes = {
      :controller => "students",
      :read_access => true,
      :write_access=> false,
    }
  end

  it "should create a new instance given valid attributes" do
    Right.create!(@valid_attributes)
  end

  it "should not be valid given a nonexistant controller" do
    pending
    right= Right.new(@valid_attributes.merge(:controller=>"NOTThere"))
    

    right.should_not be_valid
    right.should have(1).error_on(:controller)
    
  end
  
end
