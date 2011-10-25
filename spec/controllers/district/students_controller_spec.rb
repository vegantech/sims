require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::StudentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_student(stubs={})
    @mock_student ||= mock_model(Student, stubs)
  end

  before do
    @district = mock_district(:students => Student)
    controller.stub!(:current_district => @district)
  end
  
  describe "responding to GET index" do
    before do
      @district.stub_association!(:students,:paged_by_last_name=>@mock_students=[mock_student])
    end

    it "should expose all district_students as @district_students" do
      get :index
      assigns[:students].should == [mock_student]
    end
  end

  describe "responding to GET new" do
  
    it "should expose a new student as @student" do
      Student.should_receive(:new).and_return(mock_student(:enrollments => mock_enrollment(:build=>[])))
      get :new
      assigns[:student].should equal(mock_student)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested student as @student" do
      Student.should_receive(:find).with("37").and_return(mock_student(:enrollments => mock_enrollment(:build=>[],'empty?'=>true)))
      get :edit, :id => "37"
      assigns[:student].should equal(mock_student)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created student as @student" do
        Student.should_receive(:build).with({'these' => 'params'}).and_return(mock_student(:save => true))
        post :create, :student => {:these => 'params'}
        assigns(:student).should equal(mock_student)
      end

      it "should redirect to the index" do
        Student.stub!(:build).and_return(mock_student(:save => true))
        post :create, :student => {}
        response.should redirect_to(district_students_url)
      end

      it "should have flash link to the created student" do
        Student.stub!(:build).and_return(mock_student(:save => true))
        post :create, :student => {}
        flash[:notice].should match(/#{edit_district_student_path(mock_student)}/)
      end
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved student as @student" do
        Student.stub!(:build).with({'these' => 'params'}).and_return(mock_student(:save => false))
        post :create, :student => {:these => 'params'}
        assigns(:student).should equal(mock_student)
      end

      it "should re-render the 'new' template" do
        Student.stub!(:build).and_return(mock_student(:save => false))
        post :create, :student => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested student" do
        Student.should_receive(:find).with("37").and_return(mock_student)
        mock_student.should_receive(:update_attributes).with({'these' => 'params', "existing_system_flag_attributes"=>{}})
        put :update, :id => "37", :student => {:these => 'params'}
      end

      it "should expose the requested student as @student" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => true))
        put :update, :id => "1", :student => {}
        assigns(:student).should equal(mock_student)
      end

      it "should redirect to the student index" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => true))
        put :update, :id => "1", :student => {}
        response.should redirect_to(district_students_url)
      end

      it "should include a link in the flash" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => true))
        put :update, :id => "1", :student => {}
        flash[:notice].should match(/#{edit_district_student_path(mock_student)}/)
      end

    end
    
    describe "with invalid params" do

      it "should update the requested student" do
        Student.should_receive(:find).with("37").and_return(mock_student)
        mock_student.should_receive(:update_attributes).with({'these' => 'params', "existing_system_flag_attributes"=>{}})
        put :update, :id => "37", :student => {:these => 'params'}
      end

      it "should expose the student as @student" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => false))
        put :update, :id => "1", :student => {}
        assigns(:student).should equal(mock_student)
      end

      it "should re-render the 'edit' template" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => false))
        put :update, :id => "1", :student => {}
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested student" do
      Student.should_receive(:find).with("37").and_return(mock_student)
      mock_student.should_receive(:remove_from_district)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the district_students list" do
      Student.stub!(:find).and_return(mock_student(:remove_from_district => true))
      delete :destroy, :id => "1"
      response.should redirect_to(district_students_url)
    end

  end

end
