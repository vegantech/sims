class ChecklistsController < ApplicationController
  # GET /checklists/1
  def show
    @checklist=current_student.checklists.find_and_score(params[:id])
    flash[:notice] = "Checklist no longer exists." and redirect_to :back and return if @checklist.blank?
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /checklists/new
  def new
    @checklist = current_student.checklists.new_from_teacher(current_user)
    if @checklist.pending?
      flash[:notice]="Please submit/edit or delete the already started checklist first"
      redirect_to current_student and return
    end

    if @checklist.missing_checklist_definition?
      flash[:notice] = "No checklist available.  Have the content builder create one."
      redirect_to current_student and return
    end

    if current_district.tiers.blank?
      flash[:notice] = "No tiers available.  Using the checklist requires at least one tier."
      redirect_to current_student and return
    end


    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /checklists/1/edit
  def edit
    show
  end

  def update
    @checklist=current_student.checklists.find(params[:id])
    @checklist.teacher = current_user
    if @checklist.update_attributes(params.slice("commit","save_draft","element_definition"))
      flash[:notice] = "Checklist has been updated"
      if @checklist.needs_recommendation?
          redirect_to new_recommendation_url(:checklist_id=>@checklist.id) and return
      else
          redirect_to(current_student) and return
      end
    else
      flash[:notice] = "There was a problem with updating the checklist"
      render :action => 'edit' and return
    end
 end



  # POST /checklists
  # POST /checklists.xml
  def create
    #FIXME should be skinnier model
    @checklist = current_student.checklists.build(params.slice("commit","save_draft","element_definition"))
    @checklist.teacher = current_user

    respond_to do |format|
      if @checklist.save
        flash[:notice] = 'Checklist was successfully created.'
        if @checklist.needs_recommendation?
          format.html {redirect_to new_recommendation_url(:checklist_id=>@checklist.id)}
        else
          format.html { redirect_to(current_student) }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # DELETE /checklists/1
  # DELETE /checklists/1.xml
  def destroy
    @checklist = current_student.checklists.find_by_id(params[:id])
    @checklist.destroy if @checklist

    respond_to do |format|
      format.html { redirect_to(current_student) }
    end
  end
end


