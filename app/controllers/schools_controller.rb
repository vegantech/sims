class SchoolsController < ApplicationController
  def select
    if request.get?
      @schools=User.find(session[:user_id]).schools
    else
      session[:school_id]=params["school"]["id"]
      flash[:notice]=School.find(session[:school_id]).name + ' Selected' 
      redirect_to :controller=>'students',:action=>'select'
    end
  end
end
