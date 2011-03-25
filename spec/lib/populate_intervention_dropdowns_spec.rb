require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include PopulateInterventionDropdowns
describe "Populate Intervention Dropdowns Module" do
  def selected_students_ids
    [1, 2]
  end

  def session
    {:user_id => 1}
  end

  def params
    @params ||= {:intervention => {:test => true}}
  end

  def current_student
   @current_student ||= mock_student(:interventions => mock_intervention, :max_tier => max_tier)
  end

  def current_school
   @current_school ||= mock_school(:quicklist => [])
  end

  def max_tier
   @mock_tier ||= mock_tier()

  end

  def current_district
    @current_district ||= mock_district(:goal_definitions => [])
  end

  def flash
    @flash ||= {}
  end

  def mock_intervention
    @mock_intervention ||=mock_model(Intervention)
  end

  describe 'values_from_session' do
    it 'should produce a subset of the session' do
      values_from_session.should == ({:user_id => 1, :selected_ids => [1, 2], :school_id => nil})
    end
  end

  describe 'build_from_session_and_params' do
    it 'should build intervention from session and params' do
      intervention=mock_object(:intervention_probe_assignment => true)
      mock_intervention.should_receive(:build_and_initialize).with(values_from_session.merge(:test => true)).and_return(intervention)
      build_from_session_and_params.should == intervention
    end
  end


  describe 'populate_goals' do 
    it 'should populate @goal_definitions' do
      self.should_receive(:find_goal_definition).twice
      populate_goals
      @goal_definitions.should == []
      @goal_definition = true
      self.should_receive(:populate_objectives)
      populate_goals
    end
  end

  describe 'populate_objectives' do
    it 'should populate @objective_definitions' do
      self.should_receive(:find_objective_definition).twice
      @goal_definition=mock_goal_definition(:objective_definitions => [])
      populate_objectives
      @objective_definitions.should == []
      @objective_definition = true
      self.should_receive(:populate_categories)
      populate_objectives
    end
  end
 
  describe 'populate_categories' do
    it 'should populate @intervention_clusters' do
      self.should_receive(:find_intervention_cluster).twice
      @objective_definition=mock_objective_definition(:intervention_clusters => [])
      populate_categories
      @intervention_clusters.should == []
      @intervention_cluster = true
      self.should_receive(:populate_definitions)
      populate_categories
    end
  end
 
  describe 'populate_definitions' do
    it 'should populate @intervention_definitions if not custom' do
      self.should_receive(:find_intervention_definition)
      @intervention_cluster=mock_intervention_cluster(:intervention_definitions => InterventionDefinition)
      InterventionDefinition.should_receive(:restrict_tiers_and_disabled).with(max_tier).and_return([])
      populate_definitions
      @intervention_definitions.should == []
    end
    it 'should populate @intervention_definition if custom' do
      flash[:custom_intervention] = true
      self.should_receive(:find_intervention_definition)
      @intervention_cluster=mock_intervention_cluster(:intervention_definitions => InterventionDefinition)
      InterventionDefinition.should_receive(:build).and_return "1"
      self.should_receive(:populate_intervention)
      current_district.should_receive(:tiers).and_return([mock_tier])

      populate_definitions
    end
  end

   describe 'populate_intervention' do
     it 'should add intervention_definition to params[:intervention]' do
       self.should_receive(:build_from_session_and_params)
       self.should_receive(:find_intervention_definition)
       params[:intervention][:intervention_definition].should be_nil
       @intervention_definition = "test"
       @intervention_definition.should_receive(:recommended_monitors_with_custom).and_return([])
       current_school.should_receive(:assigned_users).and_return([])
       populate_intervention
       params[:intervention][:intervention_definition].should == "test"
     end
   end
end
