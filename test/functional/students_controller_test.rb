require File.dirname(__FILE__) + '/../test_helper'

class StudentsControllerTest < ActionController::TestCase

  def test_should_get_index
    #FIXME move this to rspec and add rest of tests
    get :index, {}, {:school_id=>schools(:alpha).id}
    assert_response :success
    assert_not_nil assigns(:students)
  end

end
