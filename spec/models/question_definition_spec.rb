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

  it 'should require checklist_definition_id' do
    QuestionDefinition.new(@valid_attributes.merge(:checklist_definition_id=>nil)).should_not be_valid
  end

end
