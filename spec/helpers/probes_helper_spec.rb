require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbesHelper do
  include ProbesHelper
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ProbesHelper)
  end

  describe 'probe_graph' do
    it 'should show a graph when the intervention_probe_assignment has probes' do
      ipa=InterventionProbeAssignment.new
      ipa.should_receive(:student_grade).and_return('03')
      ipa.probe_definition=ProbeDefinition.new
      ipa.end_date=Time.now
      ipa.first_date=1.day.ago
      ipa.save!
      ipa.probes.create!(:score=>2,:administered_at =>Time.now)
      probe_graph(ipa,1).should match(/style/)
      



    end

  end
  
end
