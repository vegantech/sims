require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  before do
    @student = mock_student
    @intervention_definition = mock_intervention_definition(:recommended_monitors_with_custom => [1,3,2])
    @intervention = mock_intervention(:student => @student, :comments => [], :intervention_probe_assignments=>[1],
                                      :intervention_definition => @intervention_definition, :title=>"mock_title")
    controller.stub_association!(:current_school, :assigned_users=>[])

    @interventions = [@intervention]
    @interventions.should_receive(:find).with(@intervention.id.to_s).any_number_of_times.and_return(@intervention)
    @student.stub!(:interventions=>@interventions)
    controller.stub!(:current_student=>@student)
    # build_from_session_and_params and populate_dropdowns are unit tested
    controller.stub!(:build_from_session_and_params=>@intervention)
    controller.stub_association!(:current_district, :tiers=>[mock_tier])
  end

  describe 'index' do
    #LH 464
    it 'should redirect to the root_url' do
      get :index
      response.should redirect_to(root_url)

    end


  end

  describe 'find_intervention' do
    it 'should redirect to current_student if the intervention cannot be found' do
      @student.stub!(:interventions => Intervention)
      get :edit, :id=>'no'
      flash[:notice].should == 'Record not found'
      response.should redirect_to(root_url)
    end

    describe 'alternate entry' do
      before do
        @student.should_receive(:blank?).and_return(true)
      end
      it 'should logout if the intervention cannot be found' do
        Intervention.should_receive(:find).with('33').and_return(nil)
        get :edit, :id=>'33'
        response.should redirect_to(logout_url)
      end

      it 'should logout if the student no longer exists' do
        Intervention.should_receive(:find).with('33').and_return(mock_intervention(:student=>nil))
        get :edit, :id=>'33'
        response.should redirect_to(logout_url)
      end

      it 'should logout if the user does nto have access to the student' do
        Intervention.should_receive(:find).with('33').and_return(mock_intervention(:student=>mock_student('belongs_to_user?' => false)))
        get :edit, :id=>'33'
        response.should redirect_to(logout_url)
      end

      it 'should setup the session if the user does have access to the student' do
        Intervention.should_receive(:find).with('33').and_return(i=mock_intervention(:student=>s=mock_student('belongs_to_user?' => true, :schools => [sch=mock_school]),:undo_end=>true))
        controller.stub_association!(:current_user, :schools =>[sch])
        put :undo_end, :id=>'33'

        session[:selected_student].should == s.id
        session[:selected_students].should == [s.id]
        session[:school_id].should == sch.id
        assigns(:intervention).should == i

      end
    end
  end


  describe "responding to GET show" do
    it "should expose the requested intervention as @intervention" do
      get :show, :id => @intervention.id.to_s
      assigns(:intervention).should equal(@intervention)
      assigns(:intervention_probe_assignment).should == 1
    end

  end

  describe 'without student' do
    it 'should redirect to select students with a flash message' do
      controller.should_receive(:current_student).and_return(nil)
      get :new
      response.should redirect_to(students_url)
      flash[:notice].should == "Please select a student."
    end
  end

  describe "responding to GET new" do
    before do
      controller.should_receive(:populate_goals)
    end

    it "should call populate_goals" do
      get :new
      response.should be_success
    end

    it "if the custom intervention param is there" do
      get :new, :custom_intervention => true
      response.should be_success
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested intervention as @intervention" do

      @intervention_definition.stub!(:active_progress_monitors => [1,3,2])
      @intervention.stub!(:intervention_probe_assignment =>1)
      get :edit, :id => @intervention.id.to_s
      assigns(:intervention).should equal(@intervention)
      assigns(:intervention_probe_assignment).should == 1
      assigns(:recommended_monitors).should == [1,3,2]
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      describe 'and a passed in comment' do
        it 'should also create a new comment' do
          @intervention.should_receive(:save).and_return(true)
          @intervention.should_receive(:autoassign_message).and_return('')
          post :create, :intervention => {:these => 'params', :comments => {:comment => 'fubar'}}
          assigns(:intervention).should equal(@intervention)
        end
      end

      it "should expose a newly created intervention as @intervention" do
        @intervention.should_receive(:save).and_return(true)
        @intervention.should_receive(:autoassign_message).and_return('')
        post :create, :intervention => {:these => 'params'}
        assigns(:intervention).should equal(@intervention)
      end

      it "should redirect to the student profile" do
        @intervention.should_receive(:save).and_return(true)
        @intervention.should_receive(:autoassign_message).and_return('')
        post :create, :intervention => {}
        response.should redirect_to(student_url(@student, :tn=>0,:ep=>0))
      end
    end

    describe "with invalid params" do
      before do
        @intervention.stub!(:goal_definition => mock_goal_definition, :objective_definition => mock_objective_definition,
                            :intervention_cluster => mock_intervention_cluster, :intervention_definition => mock_intervention_definition )
        controller.stub!(:populate_goals)
      end
      it "should expose a newly created but unsaved intervention as @intervention" do
        @intervention.should_receive(:save).and_return(false)
        post :create, :intervention => {:these => 'params'}
        assigns(:intervention).should equal(@intervention)
      end

      it "should re-render the 'new' template" do
        @intervention.should_receive(:save).and_return(false)
        post :create, :intervention => {}
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    before do
      controller.stub!(:current_user => mock_model(User,:id=>1))
    end
    describe "with valid params" do
      it "should update the requested intervention" do
        @intervention.should_receive(:update_attributes).with({'these' => 'params', "participant_user_ids"=>[], "comment_author" => 1, "intervention_probe_assignment"=>{}}).and_return(true)
        put :update, :id => @intervention.id.to_s, :intervention => {:these => 'params'}
      end

      it "should expose the requested intervention as @intervention" do
        @intervention.should_receive(:update_attributes).and_return(true)
        put :update, :id => @intervention.id.to_s
        assigns(:intervention).should equal(@intervention)
      end

      it "should redirect to the intervention" do
        @intervention.should_receive(:update_attributes).and_return(true)
        put :update, :id => @intervention.id.to_s
        response.should redirect_to(student_url(@student, :tn=>0,:ep=>0))
      end
    end

    describe "with invalid params" do
      before do
        controller.should_receive(:edit).and_return(true)
      end
      it "should update the requested intervention" do
        @intervention.should_receive(:update_attributes).with({"comment_author" => 1,'these' => 'params',  "participant_user_ids"=>[], "intervention_probe_assignment"=>{}})
        put :update, :id => @intervention.id.to_s, :intervention => {:these => 'params'}
      end

      it "should expose the intervention as @intervention" do
        @intervention.should_receive(:update_attributes).and_return(false)
        put :update, :id => @intervention.id.to_s
        assigns(:intervention).should equal(@intervention)
      end

      it "should re-render the 'edit' template" do
        @intervention.should_receive(:update_attributes).and_return(false)
        put :update, :id => @intervention.id.to_s
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested intervention" do
      @intervention.should_receive(:destroy)

      delete :destroy, :id => @intervention.id.to_s
    end

    it "should redirect to the interventions list" do
      @intervention.should_receive(:destroy)
      delete :destroy, :id => @intervention.id.to_s
      response.should redirect_to(student_url(@student))
    end
  end

  describe "responding to PUT end" do
    it "should end the requested intervention" do
      controller.should_receive(:current_user).and_return(mock_model(User,:id=>1))
      @intervention.should_receive(:end).with(1,nil,nil)
      put :end, :id => @intervention.id.to_s
    end

    it "should redirect to the student" do
      controller.should_receive(:current_user).and_return(mock_model(User, :id => 1))
      @intervention.should_receive(:end).with(1,nil,nil)
      put :end, :id => @intervention.id.to_s
      response.should redirect_to(student_url(@student))
    end
  end

end
