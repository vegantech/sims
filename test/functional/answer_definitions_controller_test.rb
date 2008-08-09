require 'test_helper'

class AnswerDefinitionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:answer_definitions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_answer_definition
    assert_difference('AnswerDefinition.count') do
      post :create, :answer_definition => { }
    end

    assert_redirected_to answer_definition_path(assigns(:answer_definition))
  end

  def test_should_show_answer_definition
    get :show, :id => answer_definitions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => answer_definitions(:one).id
    assert_response :success
  end

  def test_should_update_answer_definition
    put :update, :id => answer_definitions(:one).id, :answer_definition => { }
    assert_redirected_to answer_definition_path(assigns(:answer_definition))
  end

  def test_should_destroy_answer_definition
    assert_difference('AnswerDefinition.count', -1) do
      delete :destroy, :id => answer_definitions(:one).id
    end

    assert_redirected_to answer_definitions_path
  end
end
