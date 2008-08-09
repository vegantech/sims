require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:answers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_answer
    assert_difference('Answer.count') do
      post :create, :answer => { }
    end

    assert_redirected_to answer_path(assigns(:answer))
  end

  def test_should_show_answer
    get :show, :id => answers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => answers(:one).id
    assert_response :success
  end

  def test_should_update_answer
    put :update, :id => answers(:one).id, :answer => { }
    assert_redirected_to answer_path(assigns(:answer))
  end

  def test_should_destroy_answer
    assert_difference('Answer.count', -1) do
      delete :destroy, :id => answers(:one).id
    end

    assert_redirected_to answers_path
  end
end
