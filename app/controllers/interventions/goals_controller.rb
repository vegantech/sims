class Interventions::GoalsController < ApplicationController
  def show
    id = params[:goal_definition] ? params[:goal_definition][:id] : params[:id]
    @goal_definition = current_district.goal_definitions.find(id)
  end

  def index
    @goal_definitions = current_district.goal_definitions
  end
  
  def select
    redirect_to interventions_objectives_url(params[:goal_definition][:id])
  end

end
