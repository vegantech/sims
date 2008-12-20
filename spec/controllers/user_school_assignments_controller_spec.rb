require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSchoolAssignmentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_user_school_assignment(stubs={})
    @mock_user_school_assignment ||= mock_model(UserSchoolAssignment, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all user_school_assignments as @user_school_assignments" do
      UserSchoolAssignment.should_receive(:find).with(:all).and_return([mock_user_school_assignment])
      get :index
      assigns[:user_school_assignments].should == [mock_user_school_assignment]
    end

    describe "with mime type of xml" do
  
      it "should render all user_school_assignments as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        UserSchoolAssignment.should_receive(:find).with(:all).and_return(user_school_assignments = mock("Array of UserSchoolAssignments"))
        user_school_assignments.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested user_school_assignment as @user_school_assignment" do
      UserSchoolAssignment.should_receive(:find).with("37").and_return(mock_user_school_assignment)
      get :show, :id => "37"
      assigns[:user_school_assignment].should equal(mock_user_school_assignment)
    end
    
    describe "with mime type of xml" do

      it "should render the requested user_school_assignment as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        UserSchoolAssignment.should_receive(:find).with("37").and_return(mock_user_school_assignment)
        mock_user_school_assignment.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new user_school_assignment as @user_school_assignment" do
      pending
      UserSchoolAssignment.should_receive(:new).and_return(mock_user_school_assignment)
      get :new
      assigns[:user_school_assignment].should equal(mock_user_school_assignment)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested user_school_assignment as @user_school_assignment" do
      UserSchoolAssignment.should_receive(:find).with("37").and_return(mock_user_school_assignment)
      get :edit, :id => "37"
      assigns[:user_school_assignment].should equal(mock_user_school_assignment)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created user_school_assignment as @user_school_assignment" do
        pending
        UserSchoolAssignment.should_receive(:new).with({'these' => 'params'}).and_return(mock_user_school_assignment(:save => true))
        post :create, :user_school_assignment => {:these => 'params'}
        assigns(:user_school_assignment).should equal(mock_user_school_assignment)
      end

      it "should redirect to the created user_school_assignment" do
        pending
        UserSchoolAssignment.stub!(:new).and_return(mock_user_school_assignment(:save => true))
        post :create, :user_school_assignment => {}
        response.should redirect_to(user_school_assignment_url(mock_user_school_assignment))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved user_school_assignment as @user_school_assignment" do
        pending
        UserSchoolAssignment.stub!(:new).with({'these' => 'params'}).and_return(mock_user_school_assignment(:save => false))
        post :create, :user_school_assignment => {:these => 'params'}
        assigns(:user_school_assignment).should equal(mock_user_school_assignment)
      end

      it "should re-render the 'new' template" do
        pending
        UserSchoolAssignment.stub!(:new).and_return(mock_user_school_assignment(:save => false))
        post :create, :user_school_assignment => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested user_school_assignment" do
        UserSchoolAssignment.should_receive(:find).with("37").and_return(mock_user_school_assignment)
        mock_user_school_assignment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user_school_assignment => {:these => 'params'}
      end

      it "should expose the requested user_school_assignment as @user_school_assignment" do
        UserSchoolAssignment.stub!(:find).and_return(mock_user_school_assignment(:update_attributes => true))
        put :update, :id => "1"
        assigns(:user_school_assignment).should equal(mock_user_school_assignment)
      end

      it "should redirect to the user_school_assignment" do
        UserSchoolAssignment.stub!(:find).and_return(mock_user_school_assignment(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(user_school_assignment_url(mock_user_school_assignment))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested user_school_assignment" do
        UserSchoolAssignment.should_receive(:find).with("37").and_return(mock_user_school_assignment)
        mock_user_school_assignment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user_school_assignment => {:these => 'params'}
      end

      it "should expose the user_school_assignment as @user_school_assignment" do
        UserSchoolAssignment.stub!(:find).and_return(mock_user_school_assignment(:update_attributes => false))
        put :update, :id => "1"
        assigns(:user_school_assignment).should equal(mock_user_school_assignment)
      end

      it "should re-render the 'edit' template" do
        UserSchoolAssignment.stub!(:find).and_return(mock_user_school_assignment(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested user_school_assignment" do
      UserSchoolAssignment.should_receive(:find).with("37").and_return(mock_user_school_assignment)
      mock_user_school_assignment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the user_school_assignments list" do
      UserSchoolAssignment.stub!(:find).and_return(mock_user_school_assignment(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(user_school_assignments_url)
    end

  end

end
