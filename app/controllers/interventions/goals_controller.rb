class Interventions::GoalsController < ApplicationController
  include PopulateInterventionDropdowns
 
  def select
    flash.keep(:custom_intervention)
    respond_to do |format|
      format.html { redirect_to interventions_objectives_url(params[:goal_definition][:id])}
      format.js {
        populate_objectives
     }
    end
  end

end
