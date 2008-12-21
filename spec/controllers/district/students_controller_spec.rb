require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::StudentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_student(stubs={})
    @mock_student ||= mock_model(Student, stubs)
  end
  
  describe "responding to GET index" do
    before do
      district=mock_district
      controller.stub!(:current_district=>district)
      district.stub_association!(:students,:paginate_by_last_name=>@mock_students=[mock_student])
    end

    it "should expose all district_students as @district_students" do
      get :index
      assigns[:students].should == [mock_student]
    end

   

  end

  describe "responding to GET show" do

    it "should expose the requested student as @student" do
      Student.should_receive(:find).with("37").and_return(mock_student)
      get :show, :id => "37"
      assigns[:student].should equal(mock_student)
    end
    
    describe "with mime type of xml" do

      it "should render the requested student as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Student.should_receive(:find).with("37").and_return(mock_student)
        mock_student.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new student as @student" do
      Student.should_receive(:new).and_return(mock_student)
      get :new
      assigns[:student].should equal(mock_student)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested student as @student" do
      Student.should_receive(:find).with("37").and_return(mock_student)
      get :edit, :id => "37"
      assigns[:student].should equal(mock_student)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created student as @student" do
        Student.should_receive(:new).with({'these' => 'params'}).and_return(mock_student(:save => true))
        post :create, :student => {:these => 'params'}
        assigns(:student).should equal(mock_student)
      end

      it "should redirect to the created student" do
        Student.stub!(:new).and_return(mock_student(:save => true))
        post :create, :student => {}
        response.should redirect_to(district_student_url(mock_student))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved student as @student" do
        Student.stub!(:new).with({'these' => 'params'}).and_return(mock_student(:save => false))
        post :create, :student => {:these => 'params'}
        assigns(:student).should equal(mock_student)
      end

      it "should re-render the 'new' template" do
        Student.stub!(:new).and_return(mock_student(:save => false))
        post :create, :student => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested student" do
        Student.should_receive(:find).with("37").and_return(mock_student)
        mock_student.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :student => {:these => 'params'}
      end

      it "should expose the requested student as @student" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => true))
        put :update, :id => "1"
        assigns(:student).should equal(mock_student)
      end

      it "should redirect to the student" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(district_student_url(mock_student))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested student" do
        Student.should_receive(:find).with("37").and_return(mock_student)
        mock_student.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :student => {:these => 'params'}
      end

      it "should expose the student as @student" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => false))
        put :update, :id => "1"
        assigns(:student).should equal(mock_student)
      end

      it "should re-render the 'edit' template" do
        Student.stub!(:find).and_return(mock_student(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested student" do
      Student.should_receive(:find).with("37").and_return(mock_student)
      mock_student.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the district_students list" do
      Student.stub!(:find).and_return(mock_student(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(district_students_url)
    end

  end

end
