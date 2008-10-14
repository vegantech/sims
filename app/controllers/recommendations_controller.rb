class RecommendationsController < ApplicationController
  def new
    @checklist = current_student.checklists.find(params[:checklist_id])
    @recommendation = @checklist.build_recommendation
    @recommendation.set_reason_from_previous!
  end

  def create
    @checklist = current_student.checklists.find(params[:checklist_id])
    @recommendation = @checklist.build_recommendation(params[:recommendation])
    if @recommendation.save
      redirect_to current_student
    else
      render :action=>"new"
    end


  end
end

