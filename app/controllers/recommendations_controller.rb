class RecommendationsController < ApplicationController
  def new
    if params[:checklist_id]
      @checklist = current_student.checklists.find(params[:checklist_id]) 
      @recommendation = @checklist.build_recommendation
    else
      @recommendation = current_student.recommendations.build
    end
    @recommendation.set_reason_from_previous!
  end

  def create
    params[:recommendation][:draft]=!!params[:draft]
    if params[:checklist_id]
      @checklist = current_student.checklists.find(params[:checklist_id])
      @recommendation = @checklist.build_recommendation(params[:recommendation])
    else
      @recommendation = current_student.recommendations.build(params[:recommendation])
    end
    if @recommendation.save
      redirect_to current_student
    else
      render :action=>"new"
    end
  end

  def update
  end
 
  def destroy
  end
end

