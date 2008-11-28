class Interventions::ObjectivesController < ApplicationController
  include PopulateInterventionDropdowns

  def index
    flash.keep(:custom_intervention)
    populate_goals
  end

   def select
    flash.keep(:custom_intervention)
    respond_to do |format|
      format.html {  redirect_to interventions_categories_url(params[:goal_id],params[:objective_definition][:id])}
      format.js {
        populate_categories
      }
    end
  end

end
