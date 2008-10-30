# == Schema Information
# Schema version: 20081030035908
#
# Table name: answers
#
#  id                   :integer         not null, primary key
#  checklist_id         :integer
#  answer_definition_id :integer
#  text                 :text
#  created_at           :datetime
#  updated_at           :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Answer do
  before(:each) do
    @valid_attributes = {
      :text => "value for text"
    }
  end

  it "should create a new instance given valid attributes" do
    pending 'No unit test either, need to test this in isolation from checklist'
    Answer.create!(@valid_attributes)
  end
end
