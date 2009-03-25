class Interventions::DefinitionsController < ApplicationController
  include PopulateInterventionDropdowns
 
  def index
    flash.keep(:custom_intervention)
    populate_goals
  end

  def select
    flash.keep(:custom_intervention)
    respond_to do |format|
      format.html {redirect_to new_intervention_url(:goal_id => params[:goal_id], :objective_id => params[:objective_id],
                                    :category_id => params[:category_id], :definition_id => params[:intervention_definition][:id])}
      format.js {
        populate_intervention
      }
    end
  end
end