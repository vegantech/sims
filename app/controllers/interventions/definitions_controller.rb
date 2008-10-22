class Interventions::DefinitionsController < ApplicationController
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
    redirect_to new_intervention_url("intervention[intervention_definition_id]"=>params[:intervention_definition][:id])
  end

end


