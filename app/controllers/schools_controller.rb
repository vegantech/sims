class SchoolsController < ApplicationController
  def index
    @schools = current_user.authorized_schools
    flash[:notice]="No schools available" and redirect_to root_url if @schools.blank?
  end

  def select
    @school = current_user.authorized_schools(params["school"]["id"])
    # add school to session
    session[:school_id] = @school.id
    flash[:notice] = @school.name + ' Selected' 
    redirect_to search_students_url
  end




  private
  def action_group_for_current_action
    if %w{select}.include?(action_name)
      'read'
    else
      super
    end
  end


end
