class RecommendationsController < ApplicationController
  def new
    if params[:checklist_id]
      @checklist = current_student.checklists.find(params[:checklist_id])
      @recommendation = @checklist.build_recommendation
    else
      @recommendation = current_student.recommendations.build
    end
  end

  def show
    @recommendation = current_student.recommendations.find(params[:id])

  end

  def create
    params.deep_merge!(:recommendation => {:draft => !!params[:draft],
                      :user_id => current_user.id})

    if params[:checklist_id]
      @checklist = current_student.checklists.find(params[:checklist_id])
      @recommendation = @checklist.build_recommendation(params[:recommendation].merge(:school => current_school))
    else
      @recommendation = current_student.recommendations.build(params[:recommendation].merge(:student=>current_student, :school => current_school))
    end
    if @recommendation.save
      redirect_to current_student
    else
      render :action=>"new"
    end
  end

  def edit
    @recommendation = current_student.recommendations.find(params[:id])
  end

  def update
    params[:recommendation][:draft]=!!params[:draft]
    params[:recommendation][:user_id]=current_user.id
    @recommendation = current_student.recommendations.find(params[:id])
    @recommendation.promoted=false

    if  @recommendation.update_attributes(params[:recommendation])
      redirect_to current_student
    else
      render :action=>'new'
    end



  end

  def destroy
    @recommendation=current_student.recommendations.find(params[:id])
    @recommendation.destroy
    redirect_to current_student
  end
end

