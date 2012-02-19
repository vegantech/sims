class Interventions::CategoriesController < ApplicationController
  include PopulateInterventionDropdowns

  def index
    populate_goals
  end

  def create
    respond_to do |format|
      format.html do
        if params[:intervention_cluster][:id].present?
          redirect_to interventions_definitions_url(params[:goal_id],
                                                    params[:objective_id],
                                                    params[:intervention_cluster][:id],
                                                    :custom_intervention => params[:custom_intervention])
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


