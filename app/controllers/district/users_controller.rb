class District::UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = current_district.users.paged_by_last_name(params[:last_name],params[:page])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = current_district.users.build
    @schools = current_district.schools
    @user.roles << Role.find_by_name('regular_user')

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
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(district_users_url)}
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
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(district_users_url)}
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
      format.html { redirect_to(district_users_url) }
    end
  end
end
