require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe CountriesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
  fixtures :countries

  before do
    @country=mock_country
    controller.stub_association!(:current_district,:country=>@country)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:countries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_country
    assert_difference('Country.count') do
      post :create, :country => Factory.attributes_for(:country) 
    end

    assert_redirected_to countries_url
  end
  
  it 'should render new if creating invalid country' do
    Country.should_receive(:new).and_return(mock_country(:save=>false))
    post :create
    response.should be_success
    response.should render_template("new")
  end


  def test_should_get_edit
    get :edit, :id => countries(:one).id
    assert_response :success
  end

  it 'should udpate country and redirect to root_url with valid attributes' do
    @country.should_receive(:update_attributes).and_return(true)
    put :update, :id => countries(:one).id, :country => { }
    assert_redirected_to root_url
  end

  it 'should render edit if updating invalid country' do
    @country.should_receive(:update_attributes).and_return(false)
    post :update
    response.should be_success
    response.should render_template("edit")
  end


  def test_should_destroy_country
    assert_difference('Country.count', -1) do
      delete :destroy, :id => countries(:one).id
    end

    assert_redirected_to countries_path
  end

  it 'should reset_password' do
    Country.should_receive(:find).with('1').and_return(m=mock_country)
    m.should_receive(:admin_district).and_return(ad=mock_district)
    ad.should_receive(:reset_admin_password!).and_return('Reset admin password')
    put :reset_password, :id=>1
    flash[:notice].should == "Reset admin password"
    response.should redirect_to(countries_url)
  end

  it 'should recreate admin' do
    Country.should_receive(:find).with('1').and_return(m=mock_country)
    m.should_receive(:admin_district).and_return(ad=mock_district)
    ad.should_receive(:recreate_admin!).and_return('Recreate admin')
    put :recreate_admin, :id=>1
    flash[:notice].should == "Recreate admin"
    response.should redirect_to(countries_url)

  end
end
