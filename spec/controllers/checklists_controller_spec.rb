require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChecklistsController do
  it_should_behave_like "an authorized controller"
  include_context "authenticated"
  include_context "authorized"

  def mock_checklist(stubs={})
    @mock_checklist ||= mock_model(Checklist, stubs)
  end

  before do
    controller.stub!(:current_student =>@current_student=mock_student, :current_user =>@current_user=mock_user)
    @current_student.stub!(:checklists=>Checklist)
  end
  describe "responding to GET show" do

    it "should expose the requested checklist as @checklist" do
      Checklist.should_receive(:find_and_score).with("37").and_return(mock_checklist)
      get :show, :id => "37"
      assigns(:checklist).should equal(mock_checklist)
    end

    it "should set the flash if the checklist isn't found" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      Checklist.should_receive(:find_and_score).with("37").and_return(nil)
      get :show, :id => "37"
      assigns(:checklist).should be_nil
      flash[:notice].should == "Checklist no longer exists."
      response.should redirect_to(:back)
    end
  end

  describe "responding to GET new" do

    it "should expose a new checklist as @checklist" do
      controller.stub_association!(:current_district,:tiers => [1])
      Checklist.should_receive(:new_from_teacher).with(@current_user).and_return(mock_checklist('can_build?'=>true))
      get :new
      assigns(:checklist).should equal(mock_checklist)
      response.should render_template('new')
      response.should be_success
    end

    it 'should redirect to current student if a new checklist cannot be built' do
      Checklist.should_receive(:new_from_teacher).with(@current_user).and_return(mock_checklist('can_build?'=>false, :build_errors =>["error 1", "error 2"] ))
      get :new
      flash[:notice].should == "error 1; error 2"
      response.should redirect_to(student_url(@current_student))
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested checklist as @checklist" do
      Checklist.should_receive(:find_and_score).with("37").and_return(mock_checklist)
      get :edit, :id => "37"
      assigns(:checklist).should equal(mock_checklist)
    end

    it "should set the flash if the checklist isn't found" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      Checklist.should_receive(:find_and_score).with("37").and_return(nil)
      get :edit, :id => "37"
      assigns(:checklist).should be_nil
      flash[:notice].should == "Checklist no longer exists."
      response.should redirect_to(:back)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created checklist as @checklist" do
        Checklist.should_receive(:build).with('element_definition'=>'aaa', 'commit' => 'raa').and_return(mock_checklist(:save => true, 'needs_recommendation?' => false))
        mock_checklist.should_receive(:teacher=).with(@current_user)
        post :create, :these => 'params', 'element_definition'=>'aaa', 'commit' => 'raa'
        assigns(:checklist).should equal(mock_checklist)
      end

      describe 'needs recommendation' do
        it "should redirect to the recommendation when one is needed" do
          Checklist.stub!(:build).and_return(mock_checklist(:save => true, 'needs_recommendation?' => true))
          mock_checklist.should_receive(:teacher=).with(@current_user)
          post :create, :checklist => {}
          response.should redirect_to(new_recommendation_url(:checklist_id => mock_checklist.id))
        end
        it "should redirect to the student when no recommendation is needed" do
          Checklist.stub!(:build).and_return(mock_checklist(:save => true, 'needs_recommendation?' => false))
          mock_checklist.should_receive(:teacher=).with(@current_user)
          post :create, :checklist => {}
          response.should redirect_to(student_url(@current_student))
        end
      end
    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved checklist as @checklist" do
        Checklist.stub!(:build).with('element_definition'=>'aaa', 'commit' => 'raa').and_return(mock_checklist(:save => false))
        mock_checklist.should_receive(:teacher=).with(@current_user)
        post :create,  :these => 'params',:element_definition=>'aaa', :commit => 'raa'
        assigns(:checklist).should equal(mock_checklist)
      end

      it "should re-render the 'new' template" do
        Checklist.stub!(:build).and_return(mock_checklist(:save => false))
        mock_checklist.should_receive(:teacher=).with(@current_user)
        post :create, :checklist => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested checklist" do
        Checklist.should_receive(:find).with("37").and_return(mock_checklist('needs_recommendation?' => false))
        mock_checklist.should_receive(:update_attributes).with('element_definition'=>'aaa', 'commit' => 'raa')
        mock_checklist.should_receive(:teacher=).with(@current_user)
        put :update, :id => "37", :these => 'params', 'element_definition'=>'aaa', 'commit' => 'raa'
      end

      it "should expose the requested checklist as @checklist" do
        Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => true, 'needs_recommendation?' => false))
        mock_checklist.should_receive(:teacher=).with(@current_user)
        put :update, :id => "1"
        assigns(:checklist).should equal(mock_checklist)
      end

      describe 'needs_recommendation' do
        it "should redirect to the recommendation when one is needed" do
          Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => true, 'needs_recommendation?' => true))
          mock_checklist.should_receive(:teacher=).with(@current_user)
          put :update, :id => "1"
          response.should redirect_to(new_recommendation_url(:checklist_id => mock_checklist.id))
        end
        it "should redirect to the student when no recommendation is needed" do
          Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => true, 'needs_recommendation?' => false))
          mock_checklist.should_receive(:teacher=).with(@current_user)
          put :update, :id => "1"
          response.should redirect_to(student_url(@current_student))
        end

      end

    end

    describe "with invalid params" do
      it "should expose the checklist as @checklist" do
        Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => false))
        mock_checklist.should_receive(:teacher=).with(@current_user)
        put :update, :id => "1"
        assigns(:checklist).should equal(mock_checklist)
      end

      it "should re-render the 'edit' template" do
        Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => false))
        mock_checklist.should_receive(:teacher=).with(@current_user)
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested checklist" do
      Checklist.should_receive(:find_by_id).with("37").and_return(mc=mock_checklist)
      mc.should_receive(:destroy)
      get :destroy, :id => "37"
      response.should redirect_to(student_url(@current_student))
    end

    it "should set the flash if the checklist isn't found" do
      Checklist.should_receive(:find_by_id).with("37").and_return(nil)
      get :destroy, :id => "37"
      response.should redirect_to(student_url(@current_student))
    end
  end
end
