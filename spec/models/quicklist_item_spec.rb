# == Schema Information
# Schema version: 20090118224504
#
# Table name: quicklist_items
#
#  id                         :integer         not null, primary key
#  school_id                  :integer
#  district_id                :integer
#  intervention_definition_id :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuicklistItem do
  it "should create a new instance given valid attributes" do
    Factory(:quicklist_item)
  end
end
