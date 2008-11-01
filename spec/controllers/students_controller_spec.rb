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
      before do
        @user=mock_user
        @users=[1,2,3]
        @user.stub_association!(:authorized_groups,:members_for_school=>@users)
        controller.should_receive(:current_user).and_return(@user)
      end

      it 'should set users in group_users' do
        #controller.should_receive(:params).and_return(params)
       controller.should_receive(:current_school) 
       controller.send(:group_users).should ==(@users)
      end

      
      it 'should set @grades and render search template' do
        e1 = mock_enrollment(:grade => '1')
        e2 = mock_enrollment(:grade => '2')
        school = mock_school(:enrollments => [e1, e2])
        
        School.should_receive(:find).with(school.id).and_return(school)
        controller.should_receive(:student_groups).and_return([])

        get :search, {}, :school_id => school.id

        assigns[:grades].should == ['*', '1', '2']
        response.should render_template('search')
      end
    end

    describe 'POST' do
      describe 'without search criteria' do
        it 'should set error message and redraw search screen' do
          post :search
          flash[:notice].should == 'Missing search criteria'
          response.should redirect_to(:action => :search)
        end
      end

      describe 'with search criteria' do
        it 'should capture search criteria in session and redirect to students_url' do
          post :search, 'search_criteria' => {'grade' => '1', 'last_name' => 'Buckley', 'search_type' => 'Search Type'},
            'flagged_intervention_types' => ['attendance', 'math']

          response.should redirect_to(students_url)

          session[:search].should == {'flagged_intervention_types'=>['attendance', 'math'],
            'last_name'=>'Buckley', 'intervention_group_types'=>nil, 'grade'=>'1', 'search_type'=>'Search Type'}
        end
      end
    end
  end

  describe 'GET show' do
    before(:all) do
    end

    describe 'with selected student' do
      it 'should set @student, and render show template' do
        student = mock_student()
        students = mock_model(String, :find => student)
        school = mock_school(:students => students)
        School.should_receive(:find).with(school.id).and_return(school)

        get :show, {:id => student.id}, :school_id => school.id, :selected_students => ["#{student.id}"]

        response.should_not redirect_to(students_url)
        response.should render_template('show')
        assigns[:student].should == student
      end
    end

    describe 'without selected student' do
      it 'should flunk enforce_session_selections' do
        get :show, {:id => 999}
        flash[:notice].should == 'Student not selected'
        response.should redirect_to(students_url)
      end
    end
  end

  #controller.should_receive(:group_users).and_return([])
  #     controller.should_receive(:student_groups).and_return([])
end
