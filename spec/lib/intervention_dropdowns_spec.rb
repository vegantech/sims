require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


include PopulateInterventionDropdowns
describe "Populate Intervention Dropdowns Module" do
  def selected_students_ids
    [1,2]
  end

  def session
    {:user_id=>1}
  end

  def params
    @params||={:intervention=>{:test=>true}}
  end

  def current_student
   @current_student ||= current_student=mock_model(Student,:interventions=>mock_intervention)
  end

  def mock_intervention
    @mock_intervention ||=mock_model(Intervention)
  end

  
  it 'should produce a subset of the session' do
    values_from_session.should ==({:user_id => 1, :selected_ids => [1,2]})
  end

  it 'should build intervention from session and params' do
    mock_intervention.should_receive(:build_and_initialize).with(values_from_session.merge(:test=>true)).and_return("BUILD")
    build_from_session_and_params.should =="BUILD"

  end
  
end
=begin

     def populate_dropdowns
           @goal_definitions=current_district.goal_definitions
               if @intervention.intervention_definition
                       @goal_definition=@goal_definitions.find(@intervention.goal_definition.id)
                             @objective_definitions=@goal_definition.objective_definitions
                                   @objective_definition = @objective_definitions.find(@intervention.objective_definition.id)
                                         @intervention_clusters = @objective_definition.intervention_clusters
                                               @intervention_cluster = @intervention_clusters.find(@intervention.intervention_cluster.id)
                                                     @intervention_definitions = @intervention_cluster.intervention_definitions
                                                           @intervention_definition = @intervention_definitions.find(@intervention.intervention_definition.id)
                                                                 
                                                               end


                 end

=end
