require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Checklist do
  before(:each) do
    @valid_attributes = {
      :checklist_definition => 1,
      :from_tier => "1",
      :student => 1,
      :promoted => false,
      :user => 1,
      :is_draft => false,
      :district =>  1
    }
  end

  it "should create a new instance given valid attributes" do
    pending 'Test:Unit for now'
#    Checklist.create!(@valid_attributes)
  end
end
