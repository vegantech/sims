require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  before :each do 
    controller.should_receive(:current_student).any_number_of_times.and_return(mock_student(:interventions => mock_intervention))
    #build_from_session_and_params and populate_dropdowns are unit tested
    controller.should_receive(:build_from_session_and_params).any_number_of_times.and_return(mock_intervention(:student=>mock_student))
  end

  def mock_student(stubs ={})
    @mock_student ||= mock_model(Student, stubs)

  end
  def mock_intervention(stubs={})
    @mock_intervention ||= mock_model(Intervention,stubs)
  end
  
  describe "responding to GET show" do
     
    it "should expose the requested intervention as @intervention" do
      mock_intervention.should_receive(:find).with("37").and_return(mock_intervention)
      get :show, :id => "37"
      assigns[:intervention].should equal(mock_intervention)
    end
    
    describe "with mime type of xml" do

      it "should render the requested intervention as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_intervention.should_receive(:find).with("37").and_return(mock_intervention)
        mock_intervention.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should call populate_goals" do
      controller.should_receive(:populate_goals)
      get :new
      response.should be_success
    end

    it "should assign a @custom_intervention instance variable if the custom intervention param is there" do
      controller.should_receive(:populate_goals)
      get :new, :custom_intervention=>true
      response.should be_success
      flash[:custom_intervention].should == true

    end
  end

  describe "responding to GET edit" do
    it "should expose the requested intervention as @intervention" do
      mock_intervention.should_receive(:find).with("37").and_return(mock_intervention)
      get :edit, :id => "37"
      assigns[:intervention].should equal(mock_intervention)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created intervention as @intervention" do
        mock_intervention.should_receive(:save).and_return(true)
        post :create, :intervention => {:these => 'params'}
        assigns(:intervention).should equal(mock_intervention)
      end

      it "should redirect to the student profile" do
        mock_intervention.should_receive(:save).and_return(true)
        post :create, :intervention => {}
        response.should redirect_to(student_url(mock_student))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved intervention as @intervention" do
        mock_intervention.should_receive(:save).and_return(false)
        mock_intervention.should_receive(:intervention_definition_id).and_return(1)
        post :create, :intervention => {:these => 'params'}
        assigns(:intervention).should equal(mock_intervention)
      end

      it "should re-render the 'new' template" do
        mock_intervention.should_receive(:save).and_return(false)
        mock_intervention.should_receive(:intervention_definition_id).and_return(1)
        post :create, :intervention => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do

      it "should update the requested intervention" do
        mock_intervention.should_receive(:find).with("37").and_return(mock_intervention)
        mock_intervention.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention => {:these => 'params'}
      end

      it "should expose the requested intervention as @intervention" do
        mock_intervention.stub!(:find).and_return(mock_intervention(:update_attributes => true))
        mock_intervention.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
        assigns(:intervention).should equal(mock_intervention)
      end

      it "should redirect to the intervention" do
        mock_intervention.stub!(:find).and_return(mock_intervention(:update_attributes => true))
        mock_intervention.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
        response.should redirect_to(student_url(mock_student))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested intervention" do
        mock_intervention.should_receive(:find).with("37").and_return(mock_intervention)
        mock_intervention.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention => {:these => 'params'}
      end

      it "should expose the intervention as @intervention" do
        mock_intervention.stub!(:find).and_return(mock_intervention(:update_attributes => false))
        mock_intervention.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
        assigns(:intervention).should equal(mock_intervention)
      end

      it "should re-render the 'edit' template" do
        mock_intervention.stub!(:find).and_return(mock_intervention(:update_attributes => false))
        mock_intervention.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested intervention" do
      mock_intervention.should_receive(:find).with("37").and_return(mock_intervention)
      mock_intervention.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the interventions list" do
      mock_intervention.stub!(:find).and_return(mock_intervention(:destroy => true))
      mock_intervention.should_receive(:destroy)
      delete :destroy, :id => "1"
      response.should redirect_to(student_url(mock_student))
    end

  end

  describe "responding to UPDATE end" do
    it "should end the requested intervention" do
      mock_intervention.should_receive(:find).with("37").and_return(mock_intervention)
      controller.should_receive(:current_user).and_return(mock_model(User,:id=>1))
      mock_intervention.should_receive(:end).with(1)
      put :end, :id => "37"
    end
  
    it "should redirect to the interventions list" do
      mock_intervention.stub!(:find).and_return(mock_intervention)
      controller.should_receive(:current_user).and_return(mock_model(User,:id=>1))
      mock_intervention.should_receive(:end).with(1)
      put :end, :id => "37"
      response.should redirect_to(student_url(mock_student))
    end

  end


end
