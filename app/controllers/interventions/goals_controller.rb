class Interventions::GoalsController < ApplicationController
  include PopulateInterventionDropdowns


  def create
    respond_to do |format|
      format.html do
        if params[:goal_definition][:id].present?
          redirect_to interventions_objectives_url(params[:goal_definition][:id], :custom_intervention => params[:custom_intervention])
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
