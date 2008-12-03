require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe DistrictsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
  fixtures :districts
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:districts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_district
    assert_difference('District.count') do
      post :create, :district => Factory.attributes_for(:district)
    end

    assert_redirected_to district_path(assigns(:district))
  end
  
  it 'should render new if creating invalid district' do
    District.should_receive(:new).and_return(mock_district(:save=>false))
    post :create
    response.should be_success
    response.should render_template("new")
  end


  def test_should_show_district
    get :show, :id => districts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => districts(:one).id
    assert_response :success
  end

  def test_should_update_district
    put :update, :id => districts(:one).id, :district => { }
    assert_redirected_to district_path(assigns(:district))
  end

  it 'should render edit if updating invalid district' do
    District.should_receive(:find).and_return(mock_district(:update_attributes=>false))
    post :update
    response.should be_success
    response.should render_template("edit")
  end


  def test_should_destroy_district
    assert_difference('District.count', -1) do
      delete :destroy, :id => districts(:one).id
    end

    assert_redirected_to districts_path
  end
end
