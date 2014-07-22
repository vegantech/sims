require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::ProbesController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  before do
    @district=mock_district
    controller.stub!(:current_district=>@district)
    @district.stub!(:probe_definitions=>ProbeDefinition)
    @mock_probe_definition=mock_probe_definition
  end

  describe "responding to GET index" do
    it "should expose all probe_definitions as @probe_definitions_in_groups" do
      ProbeDefinition.should_receive(:group_by_cluster_and_objective).and_return([1,2,3])
      get :index
      assigns(:probe_definitions_in_groups).should == [1,2,3]
    end

  end

  describe "responding to GET show" do

    it "should expose the requested probe_definition as @probe_definition" do
      ProbeDefinition.should_receive(:find).with("37").and_return(@mock_probe_definition)
      get :show, :id => "37"
      assigns(:probe_definition).should equal(@mock_probe_definition)
    end


  end

  describe "responding to GET new" do

    it "should expose a new probe_definition as @probe_definition" do
      ProbeDefinition.should_receive(:build).and_return(@mock_probe_definition)
      @mock_probe_definition.stub_association!(:assets, :build=>true)

      get :new
      assigns(:probe_definition).should equal(@mock_probe_definition)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested probe_definition as @probe_definition" do
      ProbeDefinition.should_receive(:find).with("37").and_return(@mock_probe_definition)
      get :edit, :id => "37"
      assigns(:probe_definition).should equal(@mock_probe_definition)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created probe_definition as @probe_definition" do
        pending
        ProbeDefinition.should_receive(:build).with('these' => 'params').and_return(mpd=mock_probe_definition(:save => true))
        post :create, :probe_definition => {:these => 'params'}
        assigns(:probe_definition).should equal(mpd)
      end

      it "should redirect to the created probe_definition" do
        pending
        ProbeDefinition.stub!(:build).and_return(mpd=mock_probe_definition(:save => true))
        post :create, :probe_definition => {}
        response.should redirect_to(intervention_builder_probes_url(mpd))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved probe_definition as @probe_definition" do
        pending
        ProbeDefinition.stub!(:build).with('these' => 'params').and_return(mpd=mock_probe_definition(:save => false))
        post :create, :probe_definition => {:these => 'params'}
        assigns(:probe_definition).should equal(mpd)
      end

      it "should re-render the 'new' template" do
        pending
        ProbeDefinition.stub!(:build).and_return(mock_probe_definition(:save => false))
        post :create, :probe_definition => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested probe_definition" do
        pending
        ProbeDefinition.should_receive(:find).with("37").and_return(@mock_probe_definition)
        @mock_probe_definition.should_receive(:update_attributes).with('these' => 'params')
        put :update, :id => "37", :probe_definition => {:these => 'params'}
      end

      it "should expose the requested probe_definition as @probe_definition" do
        pending
        ProbeDefinition.stub!(:find).and_return(mpd=mock_probe_definition(:update_attributes => true))
        put :update, :id => "1"
        assigns(:probe_definition).should equal(mpd)
      end

      it "should redirect to the probe_definition" do
        pending
        ProbeDefinition.stub!(:find).and_return(mpd=mock_probe_definition(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(intervention_builder_probe_definition_url(mpd))
      end

    end

    describe "with invalid params" do

      it "should update the requested probe_definition" do
        pending
        ProbeDefinition.should_receive(:find).with("37").and_return(@mock_probe_definition)
        @mock_probe_definition.should_receive(:update_attributes).with('these' => 'params')
        put :update, :id => "37", :probe_definition => {:these => 'params'}
      end

      it "should expose the probe_definition as @probe_definition" do
        pending
        ProbeDefinition.stub!(:find).and_return(mpd=mock_probe_definition(:update_attributes => false))
        put :update, :id => "1"
        assigns(:probe_definition).should equal(mpd)
      end

      it "should re-render the 'edit' template" do
        pending
        ProbeDefinition.stub!(:find).and_return(mock_probe_definition(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end


  describe "responding to put disable" do
    it 'should toggle the active state' do
      @district.should_receive(:find_probe_definition).with("37").and_return(mpd=mock_probe_definition)
      mpd.should_receive(:toggle!)
      put :disable, :id=> "37"
      response.should redirect_to(intervention_builder_probes_url)
    end

    it 'should fail gracefully if probe no longer exists' do
      @district.should_receive(:find_probe_definition).with("37").and_return(nil)
      put :disable, :id=> "37"
      flash[:notice].should == "Progress Monitor Definition no longer exists."
      response.should redirect_to(intervention_builder_probes_url)

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested probe_definition when there are no probes and redirect" do
      @district.should_receive(:find_probe_definition).with("37").and_return(mpd=mock_probe_definition)
      mpd.stub_association!(:probes,:count=>0)
      mpd.should_receive(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(intervention_builder_probes_url)
    end

    it 'should just redirect if the probe definition does not exist' do
      @district.should_receive(:find_probe_definition).with("37").and_return(nil)
      delete :destroy, :id => "37"
      response.should redirect_to(intervention_builder_probes_url)
    end

    it 'should set the flash if there are probes assigned' do
      @district.should_receive(:find_probe_definition).with("37").and_return(mpd=mock_probe_definition)
      mpd.stub_association!(:probes,:count=>1)
      delete :destroy, :id=>"37"
      flash[:notice].should =='Progress Monitor Definition could not be deleted, it is in use.'
      response.should redirect_to(intervention_builder_probes_url)

    end



  end

end
