class Interventions::ObjectivesController < ApplicationController
  def show
  end

  def index
    @goal_definition=current_district.goal_definitions.find(params[:goal_id])
    @objective_definitions=@goal_definition.objective_definitions
    @goal_definitions=current_district.goal_definitions #not for js
  end

  def select
    redirect_to interventions_categories_url(params[:goal_id],params[:objective_definition][:id])
  end

end
