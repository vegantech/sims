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

  describe 'validation' do
    it 'should fail if the score is blank' do
      p=Probe.new
      p.should_not be_valid
    end

    it 'should be valid if it has a score' do
      p=Probe.new(:score=>5)
      p.should be_valid
    end

    it 'should not be valid if is above the maximum_score' do
      p=Probe.new(:score=>5)
      pd= ProbeDefinition.new(:maximum_score=>4)
      p.stub!(:probe_definition =>pd)
      p.should_not be_valid

      p.score=3
      p.should be_valid

    end

    it 'should not be valid if is below the minimum_score' do
      p=Probe.new(:score=>3)
      pd= ProbeDefinition.new(:minimum_score=>4)
      p.stub!(:probe_definition =>pd)
      p.should_not be_valid

      p.score=4
      p.should be_valid
    end

    it 'should not be valid if is not between the minimum_score and maximum' do
      p=Probe.new(:score=>3)
      pd= ProbeDefinition.new(:minimum_score=>4, :maximum_score => 6)
      p.stub!(:probe_definition =>pd)
      p.should_not be_valid

      p.score=4
      p.should be_valid
    end






    
  end
end
