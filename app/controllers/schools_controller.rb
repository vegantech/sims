class SchoolsController < ApplicationController
  # School Selection Controller
  skip_before_filter :verify_authenticity_token, :authorize
  layout 'main'
  def index
    @schools = current_user.schools
    flash[:notice]="No schools available" and redirect_to not_authorized_url if @schools.blank?
    if @schools.size == 1
      session[:school_id] = @schools.first.id
      flash[:notice] = "#{flash[:notice]} #{@schools.first.name} has been automatically selected."
      redirect_to next_step_url and return
    end
  end

  def show
    redirect_to action: 'index' and return
  end

  def create
    @school = current_user.schools.find(params["school"]["id"])
    # add school to session
    session[:school_id] = @school.id if @school
    flash[:notice] = @school.name + ' Selected' unless @school.blank?
    redirect_to next_step_url and return
  end

  private
  def next_step_url
    if flash[:tag_back] || !current_user.authorized_for?('students')
      not_authorized_url
    else
      school_student_search_url(current_school)
    end
  end
end
