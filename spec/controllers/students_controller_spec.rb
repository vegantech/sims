require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  describe 'get index' do
    it 'should get index when there is a current school and search criteria' do
      a=mock_enrollment(:student_id => 1)
      b=mock_enrollment(:student_id => 2)
      c=mock_enrollment(:student_id => 3)
      controller.should_receive(:student_search).and_return([a,b,c])
      controller.should_receive(:current_school_id).and_return(['a','b','c'])
      controller.should_receive(:current_district).and_return(District.new)
      get :index, {},{:search=>{}}
      response.should be_success
      assigns(:students).should == [a,b,c]
    end

    it 'should redirect to school selection if there is none selected' do
      pending
    end

    it 'should redirect to search if there is no criteria' do
      pending
    end
  end

  describe 'select' do
   describe 'without selected_students' do
      it 'should put error in flash, and rerender students index' do
        controller.should_receive(:student_search).and_return([])
        get :select

        session[:selected_students].should be_nil
        flash[:notice].should == 'No students selected'
        response.should render_template("index")
      end
    end

    describe 'with unauthorized student chosen' do
      before do
        e1=mock_enrollment
        e2=mock_enrollment
        e1.stub_association!(:student,:id=>5)
        e2.stub_association!(:student,:id=>6)

        controller.should_receive(:student_search).and_return([e1,e2])
        get :select, :id=>['1','5','6']

      end
      it 'should put error in flash' do
        flash[:notice].should == 'Unauthorized Student selected'
      end

      it 'should clear the selected students from the session' do
        session[:selected_students].should be_nil
        session[:selected_student].should be_nil
      end

      it 'should rerender the index template for students' do
        response.should render_template("index")
      end

    end

    describe 'with selected_students' do
       before do
        e1 = mock_enrollment
        e2 = mock_enrollment
        e1.stub_association!(:student,:id => "5")
        e2.stub_association!(:student,:id => "16")
        controller.should_receive(:student_search).and_return([e1,e2])
        get :select, :id => ["5", "16"]
       end
      
       it 'should set selected_students and selected_student' do
        session[:selected_students].should == ["5", "16"]
        session[:selected_student].should == "5"
      end
      
       it 'should redirect to first student' do
        response.should redirect_to(student_url("5"))
      end
    end

    # This tests ticket #94
    describe 'without selecting all possible authorized students' do
      it 'should set selected_students and selected_student' do
        e1 = mock_enrollment
        e2 = mock_enrollment
        e3 = mock_enrollment
        e1.stub_association!(:student, :id => "5")
        e2.stub_association!(:student, :id => "16")
        e3.stub_association!(:student, :id => '37')
        controller.should_receive(:student_search).and_return([e1,e2,e3])

        get :select, :id => ["5", "16"]
        flash[:notice].should_not == 'Unauthorized Student selected'
        session[:selected_students].should == ["5", "16"]
        session[:selected_student].should == "5"
      end
    end
  end

  describe 'private methods' do
    it 'should test the private methods' do
      pending
    end
    it 'should perform student search' do
      pending

      enrollments = mock_enrollment(:search => true)
      school = mock_school(:enrollments => enrollments)
      @user=mock_user(:authorized_enrollments_for_school=>enrollments)
      controller.should_receive(:current_user).at_least(:once).and_return(@user)
      controller.should_receive(:current_school).at_least(:once).and_return(school)
    end

  end
    

  describe 'search' do
    describe 'GET' do
          
      it 'should set @grades and render search template' do
        user=mock_user
        school=mock_school
        school.should_receive(:enrollment_years).and_return([1,2,3])
        controller.stub!(:current_school => school)
        controller.stub!(:current_user => user)
        school.should_receive(:grades_by_user).with(user).and_return ['*','1','2']
        user.should_receive(:filtered_groups_by_school).with(school).and_return ['g1']
        user.should_receive(:filtered_members_by_school).with(school).and_return ['m1','m2']

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
          response.should redirect_to("http://www.test.host/students/search")
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
       
        current_district=mock_district(:id=>5)
        controller.stub!(:current_district => current_district)
        student = mock_student(:district_id => current_district.id)
        Student.should_receive(:find).with(student.id.to_s).and_return(student)
        get :show, {:id => student.id}, :selected_students => ["#{student.id}"]

        response.should_not redirect_to(students_url)
        response.should render_template('show')
        assigns[:student].should == student
      end

   end

    describe 'without selected student' do
       it 'should set session if we have not set it yet, alternate entry with access' do
        pending
      end
      it 'should flunk enforce_session_selections if user does not have access' do
        controller.stub!(:current_user=>mock_user)
        student=mock_student
        student.should_receive("belongs_to_user?").and_return(false)
        Student.should_receive(:find).with("999").and_return(student)
        get :show, {:id => 999}
        flash[:notice].should == 'You do not have access to that student'
        response.should redirect_to(students_url)
      end
    end
  end

  describe 'grade_search' do
    before do
      @user=mock_user
      @school=mock_school
      controller.stub!(:current_user=>@user)
      controller.stub!(:current_school=>@school)

    end
    describe 'passed *' do
      it 'should assign same value for @groups as student_groups and @users as group_users' do
        @user.should_receive(:filtered_members_by_school).with(@school,{"grade"=>"*", "action"=>"grade_search", "controller"=>"students"}).and_return([1,2,3,4])
        @user.should_receive(:filtered_groups_by_school).with(@school,{"grade"=>"*",  "action"=>"grade_search", "controller"=>"students"}).and_return([5,6,7,8])
        
        xhr :post, :grade_search, :grade=>"*"
        assigns(:groups).should == [5,6,7,8]
        assigns(:users).should == [1,2,3,4]
        
      end
    end
    
    describe 'passed 01' do
      it 'should call filter student groups by grade and assign @groups and @users accordingly' do
        @user.should_receive(:filtered_groups_by_school).with(@school,{"grade"=>'01',  "action"=>"grade_search", "controller"=>"students"}).and_return(['g1-1','g1-3'])
        @user.should_receive(:filtered_members_by_school).with(@school,{"grade"=>'01', "action"=>"grade_search", "controller"=>"students"}).and_return(['g1-6','g1-8'])

        xhr :post, :grade_search, :grade=>"01"
        assigns(:groups).should == ['g1-1','g1-3']
        assigns(:users).should == ['g1-6','g1-8']

      end

    end
  end

  describe 'member_search' do
     before do
      @user=mock_user
      @school=mock_school
      controller.stub!(:current_user=>@user)
      controller.stub!(:current_school=>@school)

    end
    describe 'passed * for grade and "" for user' do
      it 'should assign same value for @groups as student groups' do
        @user.should_receive(:filtered_groups_by_school).with(@school,{"grade"=>'*',"user"=>"",  "action"=>"member_search", "controller"=>"students"}).and_return([1,2,3,4])

        xhr :post, :member_search, :grade=>"*", :user=>""
        assigns(:groups).should == [1,2,3,4]
      end
    end

    describe 'passed blank for user and 01 for grade' do
      it 'should call filter student groups by grade and assign @groups accordingly' do
        @user.should_receive(:filtered_groups_by_school).with(@school,{"grade"=>'01',"user"=>"",  "action"=>"member_search", "controller"=>"students"}).and_return([1,2,4])
        xhr :post, :member_search, :grade=>"01", :user=>""
        assigns(:groups).should == [1,2,4]

      end

    end

    describe 'passed 5 for user and 01 for grade' do
      it 'should filter by both grade and user' do
        @user.should_receive(:filtered_groups_by_school).with(@school,{"grade"=>'01',"user"=>"5",  "action"=>"member_search", "controller"=>"students"}).and_return([2])
        xhr :post, :member_search, :grade=>"01", :user=>"5"
        assigns(:groups).should == [2]
      end
      
    end
    
  end

  it 'has student search should call Enrollment.search' do
    Enrollment.should_receive(:search).and_return([1,2,3])
    controller.session ={:search => {}}
    #    controller.should_receive(:session).and_return({:search=>{}})
    controller.send(:student_search).should == [1,2,3]

  end
    

  #controller.should_receive(:group_users).and_return([])
  #     controller.should_receive(:student_groups).and_return([])
end
