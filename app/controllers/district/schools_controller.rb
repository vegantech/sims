class District::SchoolsController < ApplicationController
  # GET /district_schools
  # GET /district_schools.xml
  def index
    @schools = current_district.schools

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end

  # GET /district_schools/new
  # GET /district_schools/new.xml
  def new
    @school = current_district.schools.build

    # uncomment this to start off creating a user:
    # @school.user_school_assignments.build

    @users = User.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /district_schools/1/edit
  def edit
    @school = current_district.schools.find(params[:id])
    @users = User.all
  end

  # POST /district_schools
  # POST /district_schools.xml
  def create
    @school = current_district.schools.build(params[:school])

    if @school.save
      flash[:notice] = "Successfully created school and user assignments."
      redirect_to district_schools_path
    else
      @users = User.all
      render :action => 'new'
    end
  end

  # PUT /district_schools/1
  # PUT /district_schools/1.xml
  def update
    params[:school][:existing_user_school_assignment_attributes] ||= {}
    @school = current_district.schools.find(params[:id])

    if @school.update_attributes(params[:school])
      flash[:notice] = "Successfully updated school and user assignments."
      redirect_to district_schools_path
    else
      @users = User.all
      render :action => 'edit'
    end
  end

  # DELETE /district_schools/1
  # DELETE /district_schools/1.xml
  def destroy
    @school = current_district.schools.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(district_schools_url) }
      format.xml  { head :ok }
    end
  end
end
