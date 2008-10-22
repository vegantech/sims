class Interventions::GoalsController < ApplicationController
  def show
    id = params[:goal_definition] ? params[:goal_definition][:id] : params[:id]
    @goal_definition = current_district.goal_definitions.find(id)
  end

  def index
    @goal_definitions = current_district.goal_definitions
  end
  
  def select
    respond_to do |format|
      format.html { redirect_to interventions_objectives_url(params[:goal_definition][:id])}
      format.js {
        @goal_definition= current_district.goal_definitions.find(params[:goal_definition][:id])
        @objective_definitions = @goal_definition.objective_definitions
      }
    end
  end

end
