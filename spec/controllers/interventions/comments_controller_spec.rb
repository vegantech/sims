require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::CommentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_intervention_comment(stubs={})
    @mock_intervention_comment ||= mock_model(InterventionComment, stubs)
  end

  before :each do 
    student=mock_student
    @intervention=mock_intervention
    student.stub_association!(:interventions,:find=>@intervention)
    controller.stub!(:current_student).and_return(student)
  end
  
  describe "responding to GET index" do

    it "should expose all intervention_comments as @intervention_comments" do
      InterventionComment.should_receive(:find).with(:all).and_return([mock_intervention_comment])
      get :index
      assigns[:intervention_comments].should == [mock_intervention_comment]
    end

    describe "with mime type of xml" do
  
      it "should render all intervention_comments as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        InterventionComment.should_receive(:find).with(:all).and_return(intervention_comments = mock("Array of InterventionComments"))
        intervention_comments.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET new" do
  
    it "should expose a new intervention_comment as @intervention_comment" do
      InterventionComment.should_receive(:new).and_return(mock_intervention_comment)
      get :new
      assigns[:intervention_comment].should equal(mock_intervention_comment)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested intervention_comment as @intervention_comment" do
      InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
      get :edit, :id => "37"
      assigns[:intervention_comment].should equal(mock_intervention_comment)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created intervention_comment as @intervention_comment" do
        InterventionComment.should_receive(:new).with({'these' => 'params'}).and_return(mock_intervention_comment(:save => true))
        post :create, :intervention_comment => {:these => 'params'}
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should redirect to the created intervention_comment" do
        InterventionComment.stub!(:new).and_return(mock_intervention_comment(:save => true))
        post :create, :intervention_comment => {}
        response.should redirect_to(intervention_url(@intervention))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved intervention_comment as @intervention_comment" do
        InterventionComment.stub!(:new).with({'these' => 'params'}).and_return(mock_intervention_comment(:save => false))
        post :create, :intervention_comment => {:these => 'params'}
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should re-render the 'new' template" do
        InterventionComment.stub!(:new).and_return(mock_intervention_comment(:save => false))
        post :create, :intervention_comment => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested intervention_comment" do
        InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
        mock_intervention_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention_comment => {:these => 'params'}
      end

      it "should expose the requested intervention_comment as @intervention_comment" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => true))
        put :update, :id => "1"
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should redirect to the intervention_comment" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(intervention_url(@intervention))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested intervention_comment" do
        InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
        mock_intervention_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention_comment => {:these => 'params'}
      end

      it "should expose the intervention_comment as @intervention_comment" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => false))
        put :update, :id => "1"
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should re-render the 'edit' template" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested intervention_comment" do
      InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
      mock_intervention_comment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the intervention_comments list" do
      InterventionComment.stub!(:find).and_return(mock_intervention_comment(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(intervention_url(@intervention))
    end

  end

end
