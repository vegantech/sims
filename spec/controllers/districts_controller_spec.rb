require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe DistrictsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  fixtures :districts

  before do
    @district=mock_district(:admin? => true)
    District.stub!(:normal => @n=[1,2,3,4,5,6])
    District.stub!(:for_dropdown => @n)

    controller.stub!(:current_district=>@district)
  end

  describe 'responding to GET bulk_import_form' do
    it 'should run' do
      get :bulk_import_form
      response.should render_template('bulk_import_form')
      response.should be_success
    end
  end

  it 'should show index' do
    get :index
    response.should be_success
    assigns(:districts).should == [1,2,3,4,5,6]
  end

  it 'should get new' do
    get :new
    assigns(:district).new_record?.should be_true
    response.should be_success
  end

  describe 'create' do
    it 'should create district when valid' do
      @n.should_receive(:build).with(['45']).and_return(mock_district(:save=>true))
      post :create, :district => (['45'])
      flash[:notice].should ==  'District was successfully created.'

      response.should redirect_to(districts_url)
    end

    it 'should render new when  invalid district' do
      @n.should_receive(:build).with(nil).and_return(m=mock_district(:save=>false))
      post :create
      assigns(:district).should == m
      response.should render_template("new")
    end
  end

  it 'test_should_get_edit' do
    pending 'test:unuit needs updating'
    get :edit, :id => districts(:one).id
    assert_response :success
  end

  it  'test_should_update_district' do
    pending 'test unit needs updating'
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

  it 'test_should_destroy_district' do
    pending 'test unit needs updating'
    assert_difference('District.count', -1) do
      delete :destroy, :id => districts(:one).id
    end

    assert_redirected_to districts_path
  end
end
