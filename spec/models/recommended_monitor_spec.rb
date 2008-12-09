# == Schema Information
# Schema version: 20081208201532
#
# Table name: recommended_monitors
#
#  id                         :integer         not null, primary key
#  intervention_definition_id :integer
#  probe_definition_id        :integer
#  note                       :string(255)
#  position                   :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendedMonitor do
  before(:each) do
    @valid_attributes = {
      :intervention_definition_id => 1,
      :probe_definition_id => 1,
      :note => "value for note",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    RecommendedMonitor.create!(@valid_attributes)
  end
end
