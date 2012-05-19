class SchoolsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :authorize
  layout 'main'
  def index
    @schools = current_user.authorized_schools
    flash[:notice]="No schools available" and redirect_to not_authorized_url if @schools.blank?
    if @schools.size == 1 and flash[:notice].blank?
      session[:school_id] = @schools.first.id
      flash[:notice] = "#{@schools.first.name} has been automatically selected."
      redirect_to next_step_url and return
    end
  end

  def show
    redirect_to :action => 'index' and return
  end

  def select
    @school = current_user.authorized_schools(params["school"]["id"]).first
    # add school to session
    session[:school_id] = @school.id if @school
    flash[:notice] = @school.name + ' Selected' unless @school.blank?
    redirect_to next_step_url and return
  end

  private
  def next_step_url
   (current_user.authorized_for?('students') ? search_students_url : not_authorized_url)
  end


end
