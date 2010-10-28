# == Schema Information
# Schema version: 20101027022939
#
# Table name: answer_definitions
#
#  id                    :integer(4)      not null, primary key
#  element_definition_id :integer(4)
#  text                  :text
#  value                 :string(255)
#  position              :integer(4)
#  autoset_others        :boolean(1)
#  created_at            :datetime
#  updated_at            :datetime
#

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



  it 'should require value' do
    AnswerDefinition.new(@valid_attributes.merge(:value=>nil)).should_not be_valid
  end


end



