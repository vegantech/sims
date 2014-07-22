# == Schema Information
# Schema version: 20101101011500
#
# Table name: element_definitions
#
#  id                     :integer(4)      not null, primary key
#  question_definition_id :integer(4)
#  text                   :text
#  kind                   :string(255)
#  position               :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ElementDefinition do
  before(:each) do
    @valid_attributes = {
      question_definition_id: 1,
      text: "value for text",
      kind: "comment",
      position: "1",
    }
  end

  it "should create a new instance given valid attributes" do
    ElementDefinition.create!(@valid_attributes)
  end

  it 'should should require question_definition_id' do
    ElementDefinition.new(@valid_attributes.merge(question_definition_id: nil)).should_not be_valid
  end

  it  'should requiretext' do
   ElementDefinition.new(@valid_attributes.merge(text: nil)).should_not be_valid
 end

  it 'should return question kinds' do
    ElementDefinition.kinds_of_elements.should_not be_empty
  end

  it 'should require valid kind' do
    ElementDefinition.new(@valid_attributes.merge(kind: nil)).should_not be_valid
    ElementDefinition.new(@valid_attributes.merge(kind: 'lalala')).should_not be_valid
  end
end
