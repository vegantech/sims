# == Schema Information
# Schema version: 20090623023153
#
# Table name: quicklist_items
#
#  id                         :integer(4)      not null, primary key
#  school_id                  :integer(4)
#  district_id                :integer(4)
#  intervention_definition_id :integer(4)
#  created_at                 :datetime
#  updated_at                 :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuicklistItem do
  it "should create a new instance given valid attributes" do
    Factory(:quicklist_item)
  end
end
