class ConsultationFormRequestsController < ApplicationController
  before_filter :require_current_school
  # GET /consultation_form_requests/1
  # GET /consultation_form_requests/1.xml
  def show
    @consultation_form_request = ConsultationFormRequest.find(params[:id])
    @consultation_form_request = nil unless @consultation_form_request.district == current_district
  end

  # GET /consultation_form_requests/new
  # GET /consultation_form_requests/new.xml
  def new
    @consultation_form_request = ConsultationFormRequest.new
    set_users_and_teams

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

   # POST /consultation_form_requests
  # POST /consultation_form_requests.xml
  def create
    @consultation_form_request = ConsultationFormRequest.new(params[:consultation_form_request].merge(:student=>current_student,
                                                                                                      :requestor => current_user))

    respond_to do |format|
      if @consultation_form_request.save
        msg= 'Your request for information has been sent.'
        format.html { flash[:notice]=msg; redirect_to(current_student) }
        format.js { flash.now[:notice] = msg}
      else
        set_users_and_teams
        format.html { render :action => "new" }
        format.js {render :action => "new" }
      end
    end
  end

  private
  def set_users_and_teams
    if current_school.blank?

      if request.xhr?
        render :nothing => true
      else
        redirect_to schools_url
      end
      return false
    end
    @users = current_school.assigned_users
    @teams = current_school.school_teams.named
  end
end
