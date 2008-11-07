class SchoolsController < ApplicationController
  def index
    @schools = current_user.authorized_schools
  end

  def select
    @school = current_user.authorized_schools.find(params["school"]["id"])

    if current_user.has_group_for_school?(@school)
      # add school to session
      session[:school_id] = @school.id
      flash[:notice] = @school.name + ' Selected' 
      redirect_to search_students_url
    else
      flash[:notice] = "User doesn't have access to any groups at #{@school.name}"
      redirect_to schools_path
    end
  end
end
