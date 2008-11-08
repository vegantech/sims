require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentsController do
  it_should_behave_like "an authenticated controller"

  it 'should get index' do
    enrollments = mock_enrollment(:search => true)
    school = mock_school(:enrollments => enrollments)
    @user=mock_user(:authorized_enrollments_for_school=>enrollments)
    controller.should_receive(:current_user).at_least(:once).and_return(@user)
    controller.should_receive(:current_school).at_least(:once).and_return(school)
    get :index
    response.should be_success
    assigns(:students).should == true
  end

  describe 'select' do
      before do
        enrollment1=mock_enrollment(:student=>mock_student(:id=>"5"))
        enrollment2=mock_enrollment(:student=>mock_student(:id=>"16"))

        enrollments = mock_enrollment(:search => [enrollment1,enrollment2])
        school = mock_school(:enrollments => enrollments)
        controller.should_receive(:current_school).at_least(:once).and_return(school)
        @user=mock_user(:authorized_enrollments_for_school=>enrollments)
        controller.should_receive(:current_user).at_least(:once).and_return(@user)
      end
    describe 'without selected_students' do
      it 'should put error in flash, and rerender to students_url' do
        get :select

        session[:selected_students].should be_nil
        flash[:notice].should == 'No students selected'
        response.should render_template("index")
      end
    end

    describe 'with selected_students' do
      it 'should set selected_students and selected_student and go to show page' do
        get :select, :id => ["5", "16"]
 
        session[:selected_students].should == ["5", "16"]
        session[:selected_student].should == "5"
        response.should redirect_to(student_url("5"))
      end
    end
  end

  describe 'private methods' do
    it 'should test the private methods' do
      pending
    end
    it 'should set users in group_users' do
      pending
        #controller.should_receive(:params).and_return(params)
       controller.should_receive(:current_school) 
       controller.send(:group_users).should ==(@users)
      end
    it 'should set groups in student_groups' do
      pending

    end


  end
    

  describe 'search' do
    describe 'GET' do
          
      it 'should set @grades and render search template' do
        user=mock_user
        school=mock_school
        school.should_receive(:grades_by_user).with(user).and_return ['1','2']
        controller.should_receive(:current_user).and_return(user)
        controller.should_receive(:current_school).and_return(school)
        controller.should_receive(:group_users).and_return(['m1','m2'])
        controller.should_receive(:student_groups).and_return(['g1'])

        get :search

        assigns[:grades].should == ['*', '1', '2']
        assigns[:users].should == ['m1', 'm2']
        assigns[:groups].should == ['g1']
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

  describe 'grade_search' do
    describe 'passed *' do
      it 'should assign same value for @groups as student_groups and @users as group_users' do
        controller.should_receive(:filter_groups_by_grade).and_return([1,2,3,4])
        controller.should_receive(:filter_members_by_grade).and_return([5,6,7,8])
        post :grade_search, :grade=>"*"
        assigns(:users).should == [5,6,7,8]
        assigns(:groups).should == [1,2,3,4]
        
      end
    end
    
    describe 'passed 01' do
      it 'should call filter student groups by grade and assign @groups and @users accordingly' do
        controller.should_receive(:filter_groups_by_grade).with('01').and_return(['g1-1','g1-3'])
        controller.should_receive(:filter_members_by_grade).with('01').and_return(['g1-6','g1-8'])

        post :grade_search, :grade=>"01"
        assigns(:groups).should == ['g1-1','g1-3']
        assigns(:users).should == ['g1-6','g1-8']

      end

    end
  end

  describe 'member_search' do
    describe 'passed * for grade and "" for user' do
      it 'should assign same value for @groups as student groups' do
        controller.should_receive(:filter_groups_by_grade).with('*').and_return([1,2,3,4])
        post :member_search, :grade=>"*", :user=>""
        assigns(:groups).should == [1,2,3,4]
      end
    end

    describe 'passed blank for user and 01 for grade' do
      it 'should call filter student groups by grade and assign @groups accordingly' do
        controller.should_receive(:filter_groups_by_grade).with('01').and_return([1,2,4])
        post :member_search, :grade=>"01", :user=>""
        assigns(:groups).should == [1,2,4]

      end

    end

    describe 'passed 5 for user and 01 for grade' do
      it 'should filter by both grade and user' do
        controller.should_receive(:filter_groups_by_grade).with('01').and_return([1,2,4])
        controller.should_receive(:filter_groups_by_user).with('5',[1,2,4]).and_return([2])
        post :member_search, :grade=>"01", :user=>"5"
        assigns(:groups).should == [2]
      end
      
    end
    
  end
    

  #controller.should_receive(:group_users).and_return([])
  #     controller.should_receive(:student_groups).and_return([])
end
