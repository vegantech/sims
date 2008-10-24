require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

describe StudentsController do
  it_should_behave_like "an authenticated controller"

  fixtures :schools,:students
  def test_should_get_index
    #FIXME move this to rspec and add rest of tests
    get :index, {}, {:school_id=>schools(:alpha).id}
    assert_response :success
    assert_not_nil assigns(:students)
  end

end
