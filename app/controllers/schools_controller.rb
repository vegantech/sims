class SchoolsController < ApplicationController
  def index
    @schools = current_user.authorized_schools
  end

  def select
    @school=current_user.authorized_schools.find(params["school"]["id"])
    
    #add school to session
    session[:school_id] = @school.id
    flash[:notice] = @school.name + ' Selected' 
    redirect_to search_students_url
  end
end
