# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_comments
#
#  id              :integer(4)      not null, primary key
#  intervention_id :integer(4)
#  comment         :text
#  user_id         :integer(4)
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

  it 'should not allow changing user id'

  it 'should get the user from the intervention when creating'


end
