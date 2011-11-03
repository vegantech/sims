class District::UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = current_district.users.paged_by_last_name(params[:last_name],params[:page])
    redirect_to(district_users_url(:last_name => params[:last_name], :page => @users.total_pages)) and return if @users.out_of_bounds?
    capture_paged_controller_params
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = current_district.users.build
    @schools = current_district.schools
    @user.roles='regular_user'

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit  
  def edit
    @user = current_district.users.find(params[:id])
    @schools = current_district.schools
  end

  # POST /users
  # POST /users.xml
  def create
    @user = current_district.users.build(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "#{edit_obj_link(@user)} was successfully created."
        format.html { redirect_to(index_url_with_page)}
      else
        @schools = current_district.schools
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    params[:user] ||= {}
    params[:user][:existing_user_school_assignment_attributes] ||= {}
    @user = current_district.users.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "#{edit_obj_link(@user)} was successfully updated."
        if params[:user][:staff_assignments_attributes] && current_district.staff_assignments.empty?
          flash[:notice] += "  All staff assignments have been removed, upload a new staff_assignments.csv if you want to use this feature."
        end
        format.html { redirect_to(index_url_with_page)}
      else
        @schools = current_district.schools
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = current_district.users.find(params[:id])
    @user.remove_from_district

    respond_to do |format|
      format.html { redirect_to(index_url_with_page) }
    end
  end
end
