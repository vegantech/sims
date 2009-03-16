# == Schema Information
# Schema version: 20090316004509
#
# Table name: countries
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  admin      :boolean
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Country do
  it "should create a new instance given valid attributes" do
    Factory(:country)
  end
end
