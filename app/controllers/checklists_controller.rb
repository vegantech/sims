class ChecklistsController < ApplicationController
  # GET /checklists
  # GET /checklists.xml
  def index
    @checklists = Checklist.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @checklists }
    end
  end

  # GET /checklists/1
  # GET /checklists/1.xml
  def show
    @checklist=current_student.checklists.find(params[:id],:include=>{:answers=>:answer_definition})
    flash[:notice] = "Checklist no longer exists." and redirect_to :back and return if @checklist.blank?
    @checklist.score_checklist if @checklist.show_score?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @checklist }
    end
  end

  # GET /checklists/new
  # GET /checklists/new.xml
  def new
    @checklist = current_student.checklists.new_from_teacher(current_user,import_previous_answers=true,score=true)
    if @checklist.previous_checklist and (@checklist.previous_checklist.is_draft? or @checklist.previous_checklist.needs_recommendation?)
      flash[:notice]="Please submit/edit or delete the already started checklist first"
      redirect_to current_student
      return
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @checklist }
    end
  end

  # GET /checklists/1/edit
  def edit
    show
  end

  def update
    #FIXME editing checklists shouldn't be this messy, and shouldn't delete the old record.
    @checklist=Checklist.find_by_id(params[:id])
    @oldchecklist=@checklist
    @old_created_at = @checklist.created_at if @checklist
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
          format.xml  { render :xml => @checklist, :status => :created, :location => @checklist }
        else
          format.html {redirect_to new_recommendation_url(:checklist_id=>@checklist.id)}
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @checklist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checklists/1
  # DELETE /checklists/1.xml
  def destroy
    @checklist = current_student.checklists.find(params[:id])
    @checklist.destroy

    respond_to do |format|
      format.html { redirect_to(current_student) }
      format.xml  { head :ok }
    end
  end
end


