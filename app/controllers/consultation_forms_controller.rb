class ConsultationFormsController < ApplicationController
  before_filter :require_current_school
 # GET /consultation_forms/1
 # GET /consultation_forms/1.xml
  def show
    @consultation_form = ConsultationForm.find(params[:id])
    @consultation_form = nil unless @consultation_form.district == current_district

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /consultation_forms/new
  # GET /consultation_forms/new.xml
  def new
    @consultation_form = current_student.team_consultations.find(params[:team_consultation_id]).consultation_forms.build

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def edit
    @consultation_form = ConsultationForm.find_by_user_id_and_id(current_user,params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def update
    @consultation_form = ConsultationForm.find_by_user_id_and_id(current_user,params[:id])

    respond_to do |format|
      if @consultation_form.update_attributes(params[:consultation_form])
        msg= 'ConsultationForm was updated.'
        format.html { flash[:notice]=msg; redirect_to(current_student) }
        format.js { flash.now[:notice] = msg; responds_to_parent {render}}
      else
        format.js  {responds_to_parent {render}}
        format.html { render :action => "edit" }
      end

      format.html # show.html.erb
      format.js
    end
  end

  # POST /consultation_forms
  # POST /consultation_forms.xml
  def create
    @consultation_form = ConsultationForm.new(params[:consultation_form])
    @consultation_form.user = current_user
    @consultation_form.student = current_student
    @consultation_form.school = current_school

    respond_to do |format|
      if @consultation_form.save
        msg= 'ConsultationForm was successfully created.'
        format.html { flash[:notice]=msg; redirect_to(current_student) }
        format.js { flash.now[:notice] = msg; responds_to_parent {render}}
      else
        format.html { render :action => "new" }
        format.js { responds_to_parent{render} }
      end
    end
  end

  def destroy
    @consultation_form = ConsultationForm.find_by_user_id_and_id(current_user,params[:id])
    @consultation_form.destroy
    flash[:notice] = "Consultation Form has been removed"
    respond_to do |format|
      format.js
    end
  end
end
