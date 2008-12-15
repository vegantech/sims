require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe DistrictsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
  fixtures :districts

  before do
    @district=mock_district
    controller.stub!(:current_district=>@district)
  end

  def test_should_get_index
    pending
    get :index
    assert_response :success
    assert_not_nil assigns(:districts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_district
    pending "This should be created within a state"
    assert_difference('District.count') do
      post :create, :district => Factory.attributes_for(:district)
    end

    assert_redirected_to district_path(assigns(:district))
  end
  
  it 'should render new if creating invalid district' do
    pending
    District.should_receive(:new).and_return(mock_district(:save=>false))
    post :create
    response.should be_success
    response.should render_template("new")
  end


  def test_should_get_edit
    get :edit, :id => districts(:one).id
    assert_response :success
  end

  def test_should_update_district
    @district.should_receive(:update_attributes).and_return(true)
    put :update, :id => districts(:one).id, :district => { }
    assert_redirected_to root_url
  end

  it 'should render edit if updating invalid district' do
    @district.should_receive(:update_attributes).and_return(false)
    post :update
    response.should be_success
    response.should render_template("edit")
  end


  def test_should_destroy_district
    pending
    assert_difference('District.count', -1) do
      delete :destroy, :id => districts(:one).id
    end

    assert_redirected_to districts_path
  end
end
