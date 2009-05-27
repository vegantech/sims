# == Schema Information
# Schema version: 20090524185436
#
# Table name: objective_definitions
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  description        :text
#  goal_definition_id :integer
#  position           :integer
#  disabled           :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#  copied_at          :datetime
#  copied_from        :integer
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ObjectiveDefinition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :position => "1",
      :disabled => false
    }
  end

  it "should create a new instance given valid attributes" do
    ObjectiveDefinition.create!(@valid_attributes)
  end

  it 'should test destroy with a file attached LH 234' do
    #TODO this is really an issue with the links_and_attachments_lib, move (copy) this test there
    o=Factory(:objective_definition)
    o.assets.create!(:document=>File.open(File.join(RAILS_ROOT,'README')))
    lambda { o.destroy}.should_not raise_error
  end
end
