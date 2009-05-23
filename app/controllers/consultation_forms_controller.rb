class ConsultationFormsController < ApplicationController
  # GET /consultation_forms
  # GET /consultation_forms.xml
  def index
    @consultation_forms = ConsultationForm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultation_forms }
    end
  end

  # GET /consultation_forms/1
  # GET /consultation_forms/1.xml
  def show
    @consultation_form = ConsultationForm.find(params[:id])

    respond_to do |format|
      format.js
      format.html # show.html.erb
      format.xml  { render :xml => @consultation_form }
    end
  end

  # GET /consultation_forms/new
  # GET /consultation_forms/new.xml
  def new
    @consultation_form = ConsultationForm.new

    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.xml  { render :xml => @consultation_form }
    end
  end

  # GET /consultation_forms/1/edit
  def edit
    @consultation_form = ConsultationForm.find(params[:id])
  end

  # POST /consultation_forms
  # POST /consultation_forms.xml
  def create
    @consultation_form = ConsultationForm.new(params[:consultation_form])
    @consultation_form.user = current_user
    @consultation_form.student = current_student

    respond_to do |format|
      if @consultation_form.save
        msg= 'ConsultationForm was successfully created.'

        format.js { flash.now[:notice] = msg}
        format.html { flash[:notice]=msg; redirect_to(current_student) }
        format.xml  { render :xml => @consultation_form, :status => :created, :location => @consultation_form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultation_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultation_forms/1
  # PUT /consultation_forms/1.xml
  def update
    @consultation_form = ConsultationForm.find(params[:id])

    respond_to do |format|
      if @consultation_form.update_attributes(params[:consultation_form])
        flash[:notice] = 'ConsultationForm was successfully updated.'
        format.html { redirect_to(@consultation_form) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultation_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /consultation_forms/1
  # DELETE /consultation_forms/1.xml
  def destroy
    @consultation_form = ConsultationForm.find(params[:id])
    @consultation_form.destroy

    respond_to do |format|
      format.html { redirect_to(consultation_forms_url) }
      format.xml  { head :ok }
    end
  end
end
