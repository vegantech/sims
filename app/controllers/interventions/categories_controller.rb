class Interventions::CategoriesController < ApplicationController
  include PopulateInterventionDropdowns

  def index
    flash.keep(:custom_intervention)
    populate_goals
  end

  def select
    flash.keep(:custom_intervention)
    respond_to do |format|
      format.html {redirect_to interventions_definitions_url(params[:goal_id],params[:objective_id],params[:intervention_cluster][:id])}
      format.js {
        populate_definitions
     }
    end
  end


end


