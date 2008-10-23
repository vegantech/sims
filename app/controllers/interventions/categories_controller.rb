class Interventions::CategoriesController < ApplicationController
  include PopulateInterventionDropdowns
  def show
  end

  def index
    @goal_definition=current_district.goal_definitions.find(params[:goal_id])
    @objective_definitions=@goal_definition.objective_definitions
    @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id])
    @goal_definitions=current_district.goal_definitions #not for js
    @intervention_clusters = @objective_definition.intervention_clusters
  end

  def select
    respond_to do |format|
      format.html {redirect_to interventions_definitions_url(params[:goal_id],params[:objective_id],params[:intervention_cluster][:id])}
      format.js {
        @goal_definition=current_district.goal_definitions.find(params[:goal_id])
        @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id])
        @intervention_cluster=@objective_definition.intervention_clusters.find(params[:intervention_cluster][:id])
        @intervention_definitions = @intervention_cluster.intervention_definitions
      }
    end
  end


end


