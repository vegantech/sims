class Interventions::CategoriesController < ApplicationController
  include PopulateInterventionDropdowns

  def index
    flash.keep(:custom_intervention)
    populate_goals
  end

  def select
    flash.keep(:custom_intervention)
    respond_to do |format|
      format.html do
        if params[:intervention_cluster][:id].present?
          redirect_to interventions_definitions_url(params[:goal_id],params[:objective_id],params[:intervention_cluster][:id])
        else
          redirect_to :back
        end
      end
      format.js {
        populate_definitions
     }
    end
  end


end


