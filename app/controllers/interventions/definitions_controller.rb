class Interventions::DefinitionsController < ApplicationController
  include PopulateInterventionDropdowns
  def index
    @goal_definition=current_district.goal_definitions.find(params[:goal_id])
    @objective_definitions=@goal_definition.objective_definitions
    @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id])
    @goal_definitions=current_district.goal_definitions #not for js
    @intervention_clusters = @objective_definition.intervention_clusters
    @intervention_cluster = @objective_definition.intervention_clusters.find(params[:category_id])
    @intervention_definitions = @intervention_cluster.intervention_definitions
  end

  
  def select
    respond_to do |format|
      format.html {redirect_to new_intervention_url("intervention[intervention_definition_id]"=>params[:intervention_definition][:id])}
      format.js {
        @goal_definition=current_district.goal_definitions.find(params[:goal_id])
        @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id])
        @intervention_cluster=@objective_definition.intervention_clusters.find(params[:category_id])
        @intervention_definition = @intervention_cluster.intervention_definitions.find(params[:intervention_definition][:id])
        params[:intervention]={:intervention_definition_id=>@intervention_definition.id}
        build_from_session_and_params
      }
    end
  end

end


