require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtAdultContact do
  before(:each) do
    @valid_attributes = {
      :relationship => "value for relationship",
      :guardian => false,
      :firstName => "value for firstName",
      :lastName => "value for lastName",
      :homePhone => "value for homePhone",
      :workPhone => "value for workPhone",
      :cellPhone => "value for cellPhone",
      :pager => "value for pager",
      :email => "value for email",
      :streetAddress => "value for streetAddress",
      :cityStateZip => "value for cityStateZip"
    }
  end

  it "should create a new instance given valid attributes" do
    ExtAdultContact.create!(@valid_attributes)
  end
end
