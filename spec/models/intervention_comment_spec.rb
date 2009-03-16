# == Schema Information
# Schema version: 20090316004509
#
# Table name: intervention_comments
#
#  id              :integer         not null, primary key
#  intervention_id :integer
#  comment         :text
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionComment do
  before(:each) do
    @valid_attributes = {
      :comment => "value for comment",
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionComment.create!(@valid_attributes)
  end
end
