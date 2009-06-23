# == Schema Information
# Schema version: 20090623023153
#
# Table name: probe_definitions
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  description   :text
#  user_id       :integer(4)
#  district_id   :integer(4)
#  active        :boolean(1)      default(TRUE)
#  maximum_score :integer(4)
#  minimum_score :integer(4)
#  school_id     :integer(4)
#  position      :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  copied_at     :datetime
#  copied_from   :integer(4)
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
