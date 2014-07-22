# == Schema Information
# Schema version: 20101101011500
#
# Table name: ext_adult_contacts
#
#  id            :integer(4)      not null, primary key
#  student_id    :integer(4)
#  relationship  :string(255)
#  guardian      :boolean(1)
#  firstName     :string(255)
#  lastName      :string(255)
#  homePhone     :string(255)
#  workPhone     :string(255)
#  cellPhone     :string(255)
#  pager         :string(255)
#  email         :string(255)
#  streetAddress :string(255)
#  cityStateZip  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtAdultContact do
  before(:each) do
    @valid_attributes = {
      relationship: "value for relationship",
      guardian: false,
      firstName: "value for firstName",
      lastName: "value for lastName",
      homePhone: "value for homePhone",
      workPhone: "value for workPhone",
      cellPhone: "value for cellPhone",
      pager: "value for pager",
      email: "value for email",
      streetAddress: "value for streetAddress",
      cityStateZip: "value for cityStateZip"
    }
  end

  it "should create a new instance given valid attributes" do
    ExtAdultContact.create!(@valid_attributes)
  end
end
