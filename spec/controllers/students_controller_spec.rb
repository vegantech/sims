require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  describe 'get index' do
    it 'should get index when there is a current school and search criteria' do
      a=mock_enrollment(:student_id => 1)
      b=mock_enrollment(:student_id => 2)
      c=mock_enrollment(:student_id => 3)
      controller.should_receive(:setup_students_for_index)
      controller.should_receive(:student_search).and_return([a,b,c])
      controller.should_receive(:current_school_id).and_return(['a','b','c'])
      get :index, {},:search=>{}
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

  describe 'create' do
    describe 'without selected_students' do
      it 'should put error in flash, and rerender students index' do
        controller.should_receive(:student_search).and_return([])
        controller.should_receive(:setup_students_for_index)
        post :create,{}, :search=>{}

        session[:selected_students].should be_nil
        request.flash[:notice].should == 'No students selected'
        response.should render_template("index")
      end
    end

    describe 'with unauthorized student chosen' do
      before do
        e1=mock_enrollment(:student_id=>5)
        e2=mock_enrollment(:student_id=>6)

        controller.should_receive(:setup_students_for_index)
        controller.should_receive(:student_search).and_return([e1,e2])
        post :create, {:id=>['1','5','6']}, :search=>{}

      end
      it 'should put error in flash' do
        request.flash[:notice].should == 'Unauthorized Student selected, try searching again'
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
        e1 = mock(:id=>'5')
        e2 = mock(:id => '16')
        controller.should_receive(:student_search).and_return([e1,e2])
        post :create, {:id => ["5", "16"]},  :search=>{}

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
        e1 = mock_enrollment(:id=>'5')
        e2 = mock_enrollment(:id=>'16')
        e3 = mock_enrollment(:id=>'37')
        controller.should_receive(:student_search).and_return([e1,e2,e3])

        post :create, {:id => ["5", "16"]},  :search=>{}
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

    it 'should test setup_students_for_index' do
      pending
      controller.should_receive(:flags_above_threshold).and_return([])
    end

    it 'should test flags_above_threshold' do
      pending
      controller.should_receive(:current_district).and_return(District.new)

    end
  end

  describe 'GET show' do

    describe 'with selected student' do
      it 'should set @student, and render show template' do

        current_district=mock_district(:id=>5)
        controller.stub!(:current_district => current_district)
        student = mock_student(:district_id => current_district.id)
        Student.should_receive(:find).with(student.id.to_s).and_return(student)
        get :show, {:id => student.id.to_s}, :selected_students => ["#{student.id}"]

        response.should_not redirect_to(students_url)
        response.should render_template('show')
        assigns(:student).should == student
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
        get :show, :id => '999'
        flash[:notice].should == 'You do not have access to that student'
        response.should redirect_to(students_url)
      end
    end
  end

  it 'has student search should call Enrollment.search' do
    StudentSearch.should_receive(:search).and_return([1,2,3])
    session = {:search => {}}
    controller.stub!(:session => session)
    #    controller.should_receive(:session).and_return({:search=>{}})
    controller.send(:student_search).should == [1,2,3]

  end

  #controller.should_receive(:group_users).and_return([])
  #     controller.should_receive(:student_groups).and_return([])
end
