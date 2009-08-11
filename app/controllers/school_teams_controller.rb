class SchoolTeamsController < ApplicationController
  # GET /school_teams
  # GET /school_teams.xml
  def index
    @school_teams = current_school.school_teams.named(:include => :users)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @school_teams }
    end
  end

  # GET /school_teams/1
  # GET /school_teams/1.xml
  def show
    @school_team = current_school.school_teams.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school_team }
    end
  end

  # GET /school_teams/new
  # GET /school_teams/new.xml
  def new
    @school_team = SchoolTeam.new
    set_users_in_groups
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school_team }
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
        flash[:notice] = 'SchoolTeam was successfully created.'
        format.html { redirect_to(school_teams_url) }
        format.xml  { render :xml => @school_team, :status => :created, :location => @school_team }
      else
        set_users_in_groups
        format.html { render :action => "new" }
        format.xml  { render :xml => @school_team.errors, :status => :unprocessable_entity }
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
        flash[:notice] = 'SchoolTeam was successfully updated.'
        format.html { redirect_to(school_teams_url) }
        format.xml  { head :ok }
      else
        set_users_in_groups
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school_team.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
    end
  end

  private 
  def set_users_in_groups
    @users = current_school.assigned_users
    @users_in_groups = @users.in_groups_of(3, false)
  end
end
