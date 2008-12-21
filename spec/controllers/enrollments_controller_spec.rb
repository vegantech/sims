require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe  EnrollmentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
  fixtures :enrollments
  it 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:enrollments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_enrollment
    pending
    assert_difference('Enrollment.count') do
      post :create, :enrollment => { }
    end

    assert_redirected_to enrollment_path(assigns(:enrollment))
  end

  it 'should render new if creating invalid enrollment' do
    Enrollment.should_receive(:new).and_return(mock_enrollment(:save=>false))
    post :create
    response.should be_success
    response.should render_template("new")
  end

  def test_should_show_enrollment
    get :show, :id => enrollments(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => enrollments(:one).id
    assert_response :success
  end

  def test_should_update_enrollment
    pending
    put :update, :id => enrollments(:one).id, :enrollment => { }
    assert_redirected_to enrollment_path(assigns(:enrollment))
  end

  it 'should render edit if updating invalid enrollment' do
    Enrollment.should_receive(:find).and_return(mock_enrollment(:update_attributes=>false))
    post :update
    response.should be_success
    response.should render_template("edit")
  end


  def test_should_destroy_enrollment
    assert_difference('Enrollment.count', -1) do
      delete :destroy, :id => enrollments(:one).id
    end

    assert_redirected_to enrollments_path
  end
end
