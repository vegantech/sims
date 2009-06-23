# == Schema Information
# Schema version: 20090623023153
#
# Table name: recommended_monitors
#
#  id                         :integer(4)      not null, primary key
#  intervention_definition_id :integer(4)
#  probe_definition_id        :integer(4)
#  note                       :string(255)
#  position                   :integer(4)
#  created_at                 :datetime
#  updated_at                 :datetime
#  deleted_at                 :datetime
#  copied_at                  :datetime
#  copied_from                :integer(4)
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
