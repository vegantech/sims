class SchoolsController < ApplicationController
  def index
    @schools = User.find(session[:user_id]).schools
  end

  def select
    #add school to session
    school_id = params["school"]["id"]
    session[:school_id] = school_id
		session[:search] ||= {}
		session[:search][:school_id] = school_id

    flash[:notice] = School.find(session[:school_id]).name + ' Selected' 
    redirect_to :controller=>'students', :action=>'search'
  end
end
