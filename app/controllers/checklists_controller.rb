class ChecklistsController < ApplicationController
  # GET /checklists/1
  def show
    @checklist=current_student.find_checklist(params[:id])
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

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /checklists/1/edit
  def edit
    show
  end

  def update
    #FIXME editing checklists shouldn't be this messy, and shouldn't delete the old record.
    @checklist=Checklist.find(params[:id])
    @oldchecklist=@checklist
    @old_created_at = @checklist.created_at 
    create
    @checklist.created_at = @old_created_at if @old_created_at
    @checklist.save
    @oldchecklist.destroy if @oldchecklist
    return
  end



  # POST /checklists
  # POST /checklists.xml
  def create
    #FIXME should be skinnier model
    @checklist = current_student.checklists.new_from_params_and_teacher(params,current_user)

    respond_to do |format|
      if @checklist.all_valid?
        @checklist.save_all!
        flash[:notice] = 'Checklist was successfully created.'
        unless @checklist.needs_recommendation? 
          format.html { redirect_to(current_student) }
        else
          format.html {redirect_to new_recommendation_url(:checklist_id=>@checklist.id)}
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # DELETE /checklists/1
  # DELETE /checklists/1.xml
  def destroy
    @checklist = current_student.find_checklist(params[:id], show=false)
    @checklist.destroy if @checklist

    respond_to do |format|
      format.html { redirect_to(current_student) }
    end
  end
end


