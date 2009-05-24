class ConsultationFormRequestsController < ApplicationController
  # GET /consultation_form_requests
  # GET /consultation_form_requests.xml
  def index
    @consultation_form_requests = ConsultationFormRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultation_form_requests }
    end
  end

  # GET /consultation_form_requests/1
  # GET /consultation_form_requests/1.xml
  def show
    @consultation_form_request = ConsultationFormRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultation_form_request }
    end
  end

  # GET /consultation_form_requests/new
  # GET /consultation_form_requests/new.xml
  def new
    @consultation_form_request = ConsultationFormRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultation_form_request }
    end
  end

  # GET /consultation_form_requests/1/edit
  def edit
    @consultation_form_request = ConsultationFormRequest.find(params[:id])
  end

  # POST /consultation_form_requests
  # POST /consultation_form_requests.xml
  def create
    @consultation_form_request = ConsultationFormRequest.new(params[:consultation_form_request])

    respond_to do |format|
      if @consultation_form_request.save
        flash[:notice] = 'ConsultationFormRequest was successfully created.'
        format.html { redirect_to(@consultation_form_request) }
        format.xml  { render :xml => @consultation_form_request, :status => :created, :location => @consultation_form_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultation_form_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultation_form_requests/1
  # PUT /consultation_form_requests/1.xml
  def update
    @consultation_form_request = ConsultationFormRequest.find(params[:id])

    respond_to do |format|
      if @consultation_form_request.update_attributes(params[:consultation_form_request])
        flash[:notice] = 'ConsultationFormRequest was successfully updated.'
        format.html { redirect_to(@consultation_form_request) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultation_form_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /consultation_form_requests/1
  # DELETE /consultation_form_requests/1.xml
  def destroy
    @consultation_form_request = ConsultationFormRequest.find(params[:id])
    @consultation_form_request.destroy

    respond_to do |format|
      format.html { redirect_to(consultation_form_requests_url) }
      format.xml  { head :ok }
    end
  end
end
