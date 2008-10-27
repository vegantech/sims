require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentsController do
  it_should_behave_like "an authenticated controller"

  it 'should get index' do
    enrollments = mock_enrollment(:search => true)
    school = mock_school(:enrollments => enrollments)
    controller.should_receive(:current_school).and_return(school)
    get :index
    response.should be_success
    assigns(:students).should == true
  end

  describe 'select' do
    describe 'without selected_students' do
      it 'should put error in flash, and redirect to students_url' do
        get :select

        session[:selected_students].should be_nil
        flash[:notice].should == 'No students selected'
        response.should redirect_to(students_url)
      end
    end

    describe 'with selected_students' do
      it 'should set selected_students and selected_student and go to show page' do
        get :select, :id => [5, 16]

        session[:selected_students].should == [5, 16]
        session[:selected_student].should == 5
        response.should redirect_to(student_url(5))
      end
    end
  end

  describe 'search' do
    describe 'GET' do
      it 'should set @grades and render search template' do
        e1 = mock_enrollment(:grade => '1')
        e2 = mock_enrollment(:grade => '2')
        school = mock_school(:enrollments => [e1, e2])
        School.should_receive(:find).with(school.id).and_return(school)

        get :search, {}, :school_id => school.id

        assigns[:grades].should == ['*', '1', '2']
        response.should render_template('search')
      end
    end

    describe 'POST' do
    end
  end

end