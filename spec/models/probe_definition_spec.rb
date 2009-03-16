# == Schema Information
# Schema version: 20090316004509
#
# Table name: probe_definitions
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  description   :text
#  user_id       :integer
#  district_id   :integer
#  active        :boolean         default(TRUE)
#  maximum_score :integer
#  minimum_score :integer
#  school_id     :integer
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeDefinition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :active => false,
      :maximum_score => "1",
      :minimum_score => "1",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProbeDefinition.create!(@valid_attributes)
  end
end
