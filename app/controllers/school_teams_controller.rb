class SchoolTeamsController < ApplicationController
  # GET /school_teams
  # GET /school_teams.xml
  def index
    @school_teams = current_school.school_teams.named(:include => :users)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /school_teams/1
  # GET /school_teams/1.xml
  def show
    @school_team = current_school.school_teams.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /school_teams/new
  # GET /school_teams/new.xml
  def new
    @school_team = SchoolTeam.new
    set_users_in_groups
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /school_teams/1/edit
  def edit
    @school_team = current_school.school_teams.find(params[:id])
    set_users_in_groups
  end

  # POST /school_teams
  # POST /school_teams.xml
  def create
    @school_team = current_school.school_teams.build(params[:school_team])

    respond_to do |format|
      if @school_team.save
        flash[:notice] = "#{edit_obj_link(@school_team)} was successfully created.".html_safe
        format.html { redirect_to(school_teams_url) }
      else
        set_users_in_groups
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /school_teams/1
  # PUT /school_teams/1.xml
  def update
    params[:school_team][:user_ids] ||=[] if params[:school_team]
    @school_team = current_school.school_teams.find(params[:id])

    respond_to do |format|
      if @school_team.update_attributes(params[:school_team])
        flash[:notice] = "#{edit_obj_link(@school_team)} was successfully updated.".html_safe
        format.html { redirect_to(school_teams_url) }
      else
        set_users_in_groups
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /school_teams/1
  # DELETE /school_teams/1.xml
  def destroy
    @school_team = current_school.school_teams.find(params[:id])
    @school_team.destroy

    respond_to do |format|
      format.html { redirect_to(school_teams_url) }
    end
  end

  private 
  def set_users_in_groups
    @users = current_school.assigned_users
    @users_in_groups = @users.in_groups_of(3, false)
  end
end
