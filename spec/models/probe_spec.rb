# == Schema Information
# Schema version: 20090428193630
#
# Table name: probes
#
#  id                               :integer         not null, primary key
#  administered_at                  :date
#  score                            :integer
#  district_id                      :integer
#  intervention_probe_assignment_id :integer
#  created_at                       :datetime
#  updated_at                       :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Probe do
  before(:each) do
    @valid_attributes = {
      :administered_at => Time.now,
      :score => "1",
      :assessment_type => "value for assessment_type",
    }
  end

  it "should create a new instance given valid attributes" do
    Probe.create!(@valid_attributes)
  end
end
