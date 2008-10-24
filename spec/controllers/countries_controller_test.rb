require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
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
      post :create, :country => { }
    end

    assert_redirected_to country_path(assigns(:country))
  end

  def test_should_show_country
    get :show, :id => countries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => countries(:one).id
    assert_response :success
  end

  def test_should_update_country
    put :update, :id => countries(:one).id, :country => { }
    assert_redirected_to country_path(assigns(:country))
  end

  def test_should_destroy_country
    assert_difference('Country.count', -1) do
      delete :destroy, :id => countries(:one).id
    end

    assert_redirected_to countries_path
  end
end
