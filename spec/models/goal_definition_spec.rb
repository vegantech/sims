# == Schema Information
# Schema version: 20101101011500
#
# Table name: goal_definitions
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  district_id :integer(4)
#  position    :integer(4)
#  disabled    :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GoalDefinition do
  before do
    @valid_attributes = {
      title: "value for title",
      description: "value for description",
      position: "1",
      disabled: false
    }
  end

  it "should create a new instance given valid attributes" do
    GoalDefinition.create!(@valid_attributes)
  end

  describe 'objective_definitions' do
    it 'should build_with_new_asset' do
      gd=Factory(:goal_definition)
      od1=gd.objective_definitions.build
      od1.assets.build

      od2=gd.objective_definitions.build_with_new_asset
      od2.attributes.should == od1.attributes
      od1.assets.size.should == od2.assets.size
      od2.assets.first.attributes.should == od2.assets.first.attributes
    end
  end
end
