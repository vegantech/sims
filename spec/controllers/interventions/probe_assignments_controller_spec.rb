require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbeAssignmentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_intervention_probe_assignments(stubs={})
    @mock_intervention_probe_assignments ||= mock_model(InterventionProbeAssignments, stubs)
  end

  def params
    {:intervention_id=>1}
  end
  
  before do
    @student=mock_student
    @intervention=mock_intervention
    @student.stub_association!(:interventions,:find=>@intervention)
    controller.stub!(:current_student=>@student)
  end

  it 'should load_intervention' do
   controller.should_receive(:params).and_return(params)
   controller.send(:load_intervention).should ==(@intervention)
  end

  describe "responding to GET index" do

    it "should expose all intervention_probe_assignment as @intervention_probe_assignments" do
      @intervention.should_receive(:intervention_probe_assignments).and_return([])
      ipa=mock_intervention_probe_assignment
      @intervention.should_receive(:intervention_probe_assignment).and_return(ipa)
      
      get :index, :intervention_id => 1
      assigns[:intervention_probe_assignments].should == [ipa]
      assigns[:intervention].should == @intervention
      response.should be_success
    end
  end


end
