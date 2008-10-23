class Interventions::ObjectivesController < ApplicationController
  include PopulateInterventionDropdowns
  def show
  end

  def index
    @goal_definition=current_district.goal_definitions.find(params[:goal_id])
    @objective_definitions=@goal_definition.objective_definitions
    @goal_definitions=current_district.goal_definitions #not for js
  end

   def select
    respond_to do |format|
      format.html {  redirect_to interventions_categories_url(params[:goal_id],params[:objective_definition][:id])}
      format.js {
        @goal_definition=current_district.goal_definitions.find(params[:goal_id])
        @objective_definition=@goal_definition.objective_definitions.find(params[:objective_definition][:id])
        @intervention_clusters=@objective_definition.intervention_clusters
      }
    end
  end

end
