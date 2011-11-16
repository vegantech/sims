# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_probe_assignments
#
#  id                   :integer(4)      not null, primary key
#  intervention_id      :integer(4)
#  probe_definition_id  :integer(4)
#  frequency_multiplier :integer(4)
#  frequency_id         :integer(4)
#  first_date           :date
#  end_date             :date
#  enabled              :boolean(1)
#  created_at           :datetime
#  updated_at           :datetime
#  goal                 :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionProbeAssignment do
  before(:each) do
    @valid_attributes = {
      :frequency_multiplier => "1",
      :first_date => Time.now,
      :end_date => Time.now,
      :enabled => false
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionProbeAssignment.create!(@valid_attributes)
  end

  it 'should validate end_date after first_date' do
    ipa = InterventionProbeAssignment.new(@valid_attributes.merge({:end_date => Date.today.yesterday}))
    ipa.should_not be_valid
  end

  describe 'graphing' do
    describe 'line graph' do
      it 'should show the benchmarks and points when there is one data point and a grade benchmark with no min and a maximum of 6' do
        ipa = Factory(:intervention_probe_assignment)
        pd = ipa.probe_definition
        pd.update_attributes!(:maximum_score => 6, :minimum_score => nil)
        pd.probe_definition_benchmarks.create!(:grade_level => '02', :benchmark => 6)
        ipa.probes.create!(:score => 4, :administered_at => 2.days.ago)

        puts ipa.google_line_chart



      end

      it 'should have have a lot of other spects'





    end
  end
end
