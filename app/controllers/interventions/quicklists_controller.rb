class Interventions::QuicklistsController < ApplicationController
  def index
    @quicklist_intervention_definitions = (current_school || School.new).quicklist.reject(&:disabled)
  end

  def create
    @id = current_district.intervention_definitions.find(params[:intervention_definition_id])
    redirect_to new_intervention_url(goal_id: @id.goal_definition_id, objective_id: @id.objective_definition_id,
                                     category_id: @id.intervention_cluster_id, definition_id: @id.id)
  end
end
