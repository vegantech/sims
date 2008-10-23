class Interventions::ObjectivesController < ApplicationController
  include PopulateInterventionDropdowns

  def index
    populate_goals
  end

   def select
    respond_to do |format|
      format.html {  redirect_to interventions_categories_url(params[:goal_id],params[:objective_definition][:id])}
      format.js {
        populate_categories
      }
    end
  end

end
