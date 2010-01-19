class ConsultationFormRequestsController < ApplicationController
  # GET /consultation_form_requests/1
  # GET /consultation_form_requests/1.xml
  def show
    @consultation_form_request = ConsultationFormRequest.find(params[:id])
    @consultation_form_request = nil unless @consultation_form_request.district == current_district

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultation_form_request }
    end
  end

  # GET /consultation_form_requests/new
  # GET /consultation_form_requests/new.xml
  def new
    @consultation_form_request = ConsultationFormRequest.new
    set_users_and_teams

    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.xml  { render :xml => @consultation_form_request }
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
        format.js { flash.now[:notice] = msg}
        format.html { flash[:notice]=msg; redirect_to(current_student) }
        format.xml  { render :xml => @consultation_form, :status => :created, :location => @consultation_form }
      else
        set_users_and_teams
        format.js {render :action => "new" }
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultation_form_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  private
  def set_users_and_teams
    @users = current_school.assigned_users
    @teams = current_school.school_teams.named
  end
end
