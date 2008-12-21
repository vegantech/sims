class UserSchoolAssignmentsController < ApplicationController
  # GET /user_school_assignments
  # GET /user_school_assignments.xml
  def index
    @user_school_assignments = UserSchoolAssignment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_school_assignments }
    end
  end

  # GET /user_school_assignments/1
  # GET /user_school_assignments/1.xml
  def show
    @user_school_assignment = UserSchoolAssignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_school_assignment }
    end
  end

  # GET /user_school_assignments/new
  # GET /user_school_assignments/new.xml
  def new
    @user_school_assignment = UserSchoolAssignment.new(params[:user_school_assignment])
    
    if params[:obj]== "school"
      @objs = current_district.schools
      @obj = "school"
    else
      @objs = current_district.users
      @obj = "user"
    end

    respond_to do |format|
      format.js { }
      format.html # new.html.erb
      format.xml  { render :xml => @user_school_assignment }
    end
  end

  # GET /user_school_assignments/1/edit
  def edit
    @user_school_assignment = UserSchoolAssignment.find(params[:id])
  end

  # POST /user_school_assignments
  # POST /user_school_assignments.xml
  def create
    @user_school_assignment = UserSchoolAssignment.new(params[:user_school_assignment])
    if @user_school_assignment.school_id.blank?
      @obj="user"
    else
      @obj="school"
    end
    respond_to do |format|
      format.js {}
      format.html { redirect_to(@user_school_assignment) }
      format.xml  { render :xml => @user_school_assignment, :status => :created, :location => @user_school_assignment }
    end
  end

  # PUT /user_school_assignments/1
  # PUT /user_school_assignments/1.xml
  def update
    @user_school_assignment = UserSchoolAssignment.find(params[:id])

    respond_to do |format|
      if @user_school_assignment.update_attributes(params[:user_school_assignment])
        flash[:notice] = 'UserSchoolAssignment was successfully updated.'
        format.html { redirect_to(@user_school_assignment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_school_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_school_assignments/1
  # DELETE /user_school_assignments/1.xml
  def destroy
    @user_school_assignment = UserSchoolAssignment.find(params[:id])
    @user_school_assignment.destroy

    respond_to do |format|
      format.html { redirect_to(user_school_assignments_url) }
      format.xml  { head :ok }
    end
  end
end
