# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :multiple_selected_students?, :selected_students_ids, 
    :current_student_id
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f94867ed424ccea84323251f7aa373db'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  #

  
  private
  def current_user_id
    session[:user_id]
  end

  def current_user
    @user=User.find(current_user_id)
  end

  def selected_students_ids
    session[:selected_students]  
  end

  def multiple_selected_students?
    selected_students_ids.size > 1
  end

  def current_student_id
    session[:selected_student]
  end


  def current_student
    @student=Student.find(current_student_id)
  end

  def current_school_id
    session[:school_id]
  end

  def current_school
    @school=School.find(current_school_id)
  end

  def current_district_id
    nil
  end

  def current_district
    @district=District.find(current_district_id)
  end

end
