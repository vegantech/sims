class District::SchoolsController < ApplicationController
  # GET /district_schools
  # GET /district_schools.xml
  def index
    @schools = current_district.schools

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /district_schools/new
  # GET /district_schools/new.xml
  def new
    @school = current_district.schools.build

    # uncomment this to start off creating a user:
    # @school.user_school_assignments.build
    set_users

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /district_schools/1/edit
  def edit
    @school = current_district.schools.find(params[:id])
    set_users
  end

  # POST /district_schools
  # POST /district_schools.xml
  def create
    @school = current_district.schools.build(params[:school])

    if @school.save
      flash[:notice] = "Successfully created #{edit_obj_link(@school)}.".html_safe
      redirect_to district_schools_path
    else
      set_users
      render action: 'new'
    end
  end

  # PUT /district_schools/1
  # PUT /district_schools/1.xml
  def update
    params[:school] ||= {}
    @school = current_district.schools.find(params[:id])

    if @school.update_attributes(params[:school])
      flash[:notice] = "Successfully updated school and user assignments for #{edit_obj_link(@school)}".html_safe
      redirect_to district_schools_path
    else
      set_users
      render action: 'edit'
    end
  end

  # DELETE /district_schools/1
  # DELETE /district_schools/1.xml
  def destroy
    @school = current_district.schools.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(district_schools_url) }
    end
  end

  private
  def set_users
    @users = current_district.users unless current_district.users.size > 100
  end
end
