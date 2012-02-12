require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbesHelper do
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ProbesHelper)
  end

  describe 'probe_graph' do
    it 'should have better specs!'
    it 'should show a graph when the intervention_probe_assignment has probes' do
      ipa = Factory(:intervention_probe_assignment)
      helper.probe_graph(ipa,1).should match(/style/)
    end

  end
end
