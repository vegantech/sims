# == Schema Information
# Schema version: 20101027022939
#
# Table name: question_definitions
#
#  id                      :integer(4)      not null, primary key
#  checklist_definition_id :integer(4)
#  text                    :text
#  position                :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionDefinition do
  before(:each) do
    @valid_attributes = {
      :checklist_definition_id =>1 ,
      :text => "value for text",
      :position => "1",
    }
  end

  it "should create a new instance given valid attributes" do
    QuestionDefinition.create!(@valid_attributes)
  end


  it 'should require_text' do
    QuestionDefinition.new(@valid_attributes.merge(:text=>nil)).should_not be_valid
  end


end
