require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AnswerDefinition do
  before(:each) do
    @valid_attributes = {
      :element_definition_id =>1 ,
      :text => "value for text",
      :value => "value for kind",
      :position => "1",
      :autoset_others => false,
    }
  end

  it "should create a new instance given valid attributes" do
    AnswerDefinition.create!(@valid_attributes)
  end



  it 'should require element_definition_id' do
    AnswerDefinition.new(@valid_attributes.merge(:element_definition_id=>nil)).should_not be_valid
 end

  it 'should require value' do
    AnswerDefinition.new(@valid_attributes.merge(:value=>nil)).should_not be_valid
  end


end



