# == Schema Information
# Schema version: 20090623023153
#
# Table name: checklist_definitions
#
#  id                           :integer(4)      not null, primary key
#  text                         :text
#  directions                   :text
#  active                       :boolean(1)
#  district_id                  :integer(4)
#  created_at                   :datetime
#  updated_at                   :datetime
#  recommendation_definition_id :integer(4)
#  document_file_name           :string(255)
#  document_content_type        :string(255)
#  document_file_size           :integer(4)
#  document_updated_at          :datetime
#  deleted_at                   :datetime
#  copied_at                    :datetime
#  copied_from                  :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChecklistDefinition do
  before(:each) do
    @district = District.first || Factory(:district)
    @valid_attributes = {
      :text => "value for text",
      :directions => "value for directions",
      :active => false,
      :district => @district
    }
  end

  it "should create a new instance given valid attributes" do
    ChecklistDefinition.create!(@valid_attributes)
  end
 

  it "should return the active_checklist_definition" do
      c=ChecklistDefinition.find_by_active(true) || ChecklistDefinition.create!(@valid_attributes.merge(:active=>true))
      ChecklistDefinition.active_checklist_definition.should ==(c)
  end

  
  it "should require directions and text" do
    c=ChecklistDefinition.new(@valid_attributes)
    c.should be_valid

    c.directions=nil
    c.should_not be_valid
    
    c=ChecklistDefinition.new(@valid_attributes)
    c.text=nil
    c.should_not be_valid

  end

  it "should deactivate active checklist when saving a new one" do
    first=@district.checklist_definitions.create!(@valid_attributes)
    first.active=true
    first.save!
    second=@district.checklist_definitions.create!(@valid_attributes)
    second.active=true
    second.save!
    first.reload.active?.should be_false
  end

end

