class TeamSchedulersController < ApplicationController
  # GET /team_schedulers
  # GET /team_schedulers.xml
  def index
    @users_in_groups = current_school.users.in_groups_of(3, false) 

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /team_schedulers
  def create
    current_school.team_scheduler_user_ids = params[:user_ids].to_a
    flash[:notice] = "The team schedulers have been assigned."
    redirect_to(team_schedulers_url) 
  end
end
