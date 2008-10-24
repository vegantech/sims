require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentsController do
  it_should_behave_like "an authenticated controller"

  it 'should get index' do
    enrollments=mock_enrollment(:search=>true)
    school=mock_school(:enrollments=>enrollments)
    controller.should_receive(:current_school).and_return(school)
    get :index
    response.should be_success
    assigns(:students).should == true

  end

end
