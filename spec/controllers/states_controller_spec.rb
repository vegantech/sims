require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe StatesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
  fixtures :states
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:states)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_state
    assert_difference('State.count') do
      post :create, :state => { }
    end

    assert_redirected_to state_path(assigns(:state))
  end
  it 'should render new if creating invalid state' do
    State.should_receive(:new).and_return(mock_state(:save=>false))
    post :create
    response.should be_success
    response.should render_template("new")
  end


  def test_should_show_state
    get :show, :id => states(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => states(:one).id
    assert_response :success
  end

  def test_should_update_state
    put :update, :id => states(:one).id, :state => { }
    assert_redirected_to state_path(assigns(:state))
  end

  it 'should render edit if updating invalid state' do
    State.should_receive(:find).and_return(mock_state(:update_attributes=>false))
    post :update
    response.should be_success
    response.should render_template("edit")
  end


  def test_should_destroy_state
    assert_difference('State.count', -1) do
      delete :destroy, :id => states(:one).id
    end

    assert_redirected_to states_path
  end
end
