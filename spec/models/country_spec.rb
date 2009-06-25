# == Schema Information
# Schema version: 20090623023153
#
# Table name: countries
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  admin      :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Country do
  it "should create a new instance given valid attributes" do
    Factory(:country)
  end
end
