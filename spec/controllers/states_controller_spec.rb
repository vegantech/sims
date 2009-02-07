require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe StatesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  before do
    
    @state=mock_state
    @country = mock_country
    controller.stub_association!(:current_district, :state=>@state, :country => @country)

  end

  it 'should assign states and country for index' do
    @country.stub_association!(:states,:normal=>['normal'])
    get :index
    assigns(:states).should == ['normal']
    assigns(:country).should == @country
  end

  it 'should assign state for get new' do
    State.should_receive(:new).and_return(@state)
    get :new
    assigns(:state).should == @state
  end

  describe 'create' do
    before do
      @country.should_receive(:states).and_return(State)
    end

    it 'should assign state and redirect to states_url when save is successful' do
      attr = {'cat'=>'dog'}
      State.should_receive(:build).with(attr).and_return(@state)
      @state.should_receive(:save).and_return(true)
      post :create, :state=>attr
      response.should redirect_to(states_url)
    end
    
    it 'should render new if creating invalid state' do
      State.should_receive(:build).and_return(mock_state(:save=>false))
      post :create
      response.should be_success
      response.should render_template("new")
    end
  end


   it 'should assign @state when get edit' do
    get :edit, :id => '1'
    response.should be_success
    assigns(:state).should == @state
  end

  it 'should put update and redirect to root_url' do
    @state.should_receive(:update_attributes).and_return(true)
    put :update
    response.should redirect_to(root_url)
  end


  it 'should render edit if updating invalid state' do
    @state.should_receive(:update_attributes).and_return(false)
    post :update
    response.should be_success
    response.should render_template("edit")
  end


  it 'should destroy state ' do
    @country.should_receive(:states).and_return(State)
    State.should_receive(:find).with('1').and_return(@state)
    @state.should_receive(:destroy)
    @state.should_receive(:errors).and_return({})
    delete :destroy, :id => '1'
    @response.should redirect_to(states_path)
  end
end
