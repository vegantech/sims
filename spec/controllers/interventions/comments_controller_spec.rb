require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::CommentsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_intervention_comment(stubs={})
    @mock_intervention_comment ||= mock_model(InterventionComment, stubs)
  end

  before :each do
    @student = mock_student
    @intervention = mock_intervention
    @student.stub_association!(:interventions,:find=>@intervention)
    @intervention.stub!(:comments).and_return(InterventionComment)
    controller.stub!(:current_student).and_return(@student)
    @user = mock_user
    controller.stub!(:current_user).and_return(@user)
  end

  describe "responding to GET new" do
    it "should expose a new intervention_comment as @intervention_comment" do
      InterventionComment.should_receive(:build).and_return(mock_intervention_comment)
      get :new, :intervention_id => @intervention.id
      assigns(:intervention_comment).should equal(mock_intervention_comment)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested intervention_comment as @intervention_comment" do
      InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
      get :edit, :id => "37", :intervention_id => @intervention.id
      assigns(:intervention_comment).should equal(mock_intervention_comment)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created intervention_comment as @intervention_comment" do
        InterventionComment.should_receive(:build).with('these' => 'params', 'user'=>@user).and_return(mock_intervention_comment(:save => true))
        post :create, :intervention_comment => {:these => 'params'}, :intervention_id => @intervention.id
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should redirect to the created intervention_comment" do
        InterventionComment.stub!(:build).and_return(mock_intervention_comment(:save => true))
        post :create, :intervention_comment => {}, :intervention_id => @intervention.id
        response.should redirect_to(intervention_url(@intervention))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved intervention_comment as @intervention_comment" do
        InterventionComment.stub!(:build).with('these' => 'params', 'user'=>@user).and_return(mock_intervention_comment(:save => false))
        post :create, :intervention_comment => {:these => 'params'}, :intervention_id => @intervention.id
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should re-render the 'new' template" do
        InterventionComment.stub!(:build).and_return(mock_intervention_comment(:save => false))
        post :create, :intervention_comment => {}, :intervention_id => @intervention.id
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested intervention_comment" do
        InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
        mock_intervention_comment.stub!('comment=' => false)
        mock_intervention_comment.should_receive(:update_attributes).with('these' => 'params', 'user'=>@user)
        put :update, :id => "37", :intervention_comment => {:these => 'params'}, :intervention_id => @intervention.id
      end

      it "should expose the requested intervention_comment as @intervention_comment" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => true, 'user=' => false))
        mock_intervention_comment.stub!('comment=' => false)
        put :update, :id => "1", :intervention_comment =>{}, :intervention_id => @intervention.id
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should show a confirmation page and close" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => true, 'user=' => false))
        mock_intervention_comment.stub!('comment=' => false)
        put :update, :id => "1", :intervention_comment =>{}, :format => 'html', :intervention_id => @intervention.id
        response.should be_success
        # redirect_to(intervention_url(@intervention))
      end

    end

    describe "with invalid params" do

      it "should update the requested intervention_comment" do
        InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
        mock_intervention_comment.stub!('comment=' => false)
        mock_intervention_comment.should_receive(:update_attributes).with('these' => 'params', 'user'=>@user)
        put :update, :id => "37", :intervention_comment => {:these => 'params'}, :intervention_id => @intervention.id
      end

      it "should expose the intervention_comment as @intervention_comment" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => false, 'user=' => false))
        mock_intervention_comment.stub!('comment=' => false)
        put :update, :id => "1", :intervention_comment =>{}, :intervention_id => @intervention.id
        assigns(:intervention_comment).should equal(mock_intervention_comment)
      end

      it "should re-render the 'edit' template" do
        InterventionComment.stub!(:find).and_return(mock_intervention_comment(:update_attributes => false, 'user=' => false))
        mock_intervention_comment.stub!('comment=' => false)
        put :update, :id => "1", :intervention_comment =>{}, :intervention_id => @intervention.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested intervention_comment" do
      InterventionComment.should_receive(:find).with("37").and_return(mock_intervention_comment)
      mock_intervention_comment.should_receive(:destroy)
      delete :destroy, :id => "37", :intervention_id => @intervention.id
    end

    it "should redirect to the intervention_comments list" do
      InterventionComment.stub!(:find).and_return(mock_intervention_comment(:destroy => true))
      delete :destroy, :id => "1", :format => 'html', :intervention_id => @intervention.id
      response.should redirect_to(student_url(@student))
    end

  end

end
