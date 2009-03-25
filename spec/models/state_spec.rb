# == Schema Information
# Schema version: 20090325221606
#
# Table name: states
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#  admin      :boolean
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe State do
  it "should create a new instance given valid attributes" do
    Factory(:state)
  end
end
