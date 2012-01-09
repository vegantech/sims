require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeGraph do
  describe 'graphing' do
    describe 'line graph' do
      it 'should show the benchmarks and points when there is one data point and a grade benchmark with no min and a maximum of 6' do
        pending
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
