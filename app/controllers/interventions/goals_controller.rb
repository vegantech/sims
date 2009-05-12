class Interventions::GoalsController < ApplicationController
  include PopulateInterventionDropdowns
 
  def select
    flash.keep(:custom_intervention)
    respond_to do |format|
      format.html do
        if params[:goal_definition][:id].present?
          redirect_to interventions_objectives_url(params[:goal_definition][:id])
        else
          redirect_to :back
        end
      end
      format.js {
        populate_objectives
     }
    end
  end

end
