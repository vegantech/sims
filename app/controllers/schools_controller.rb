class SchoolsController < ApplicationController
  def index
    @schools = current_user.authorized_schools
    flash[:notice]="No schools available" and redirect_to root_url if @schools.blank?
  end

  def select
    @school = current_user.authorized_schools(params["school"]["id"]).first
    # add school to session
    session[:school_id] = @school.id if @school
    flash[:notice] = @school.name + ' Selected' unless @school.blank?
    redirect_to search_students_url
  end


end
