class CustomProbesController < ApplicationController
  # GET /custom_probes
  # GET /custom_probes.xml
  def index
    @custom_probes = ProbeDefinition.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @custom_probes }
    end
  end

  # GET /custom_probes/1
  # GET /custom_probes/1.xml
  def show
    @custom_probe = ProbeDefinition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @custom_probe }
    end
  end

  # GET /custom_probes/new
  # GET /custom_probes/new.xml
  def new
    @probe_definition = ProbeDefinition.new
    @intervention = Intervention.find(params[:intervention])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @probe_definition }
    end
  end

  # GET /custom_probes/1/edit
  def edit
    @custom_probe = ProbeDefinition.find(params[:id])
  end

  # POST /custom_probes
  # POST /custom_probes.xml
  def create
    @intervention = current_student.interventions.find(params[:intervention])
    @probe_definition = @intervention.build_custom_probe(params[:probe_definition])

    respond_to do |format|
      if @probe_definition.save
        flash[:notice] = 'Custom Probe Definition was successfully created.'
        format.html { redirect_to(intervention_probe_assignments_url(@intervention)) }
        format.xml  { render :xml => @probe_definition, :status => :created, :location => @probe_definition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @probe_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /custom_probes/1
  # PUT /custom_probes/1.xml
  def update
    @custom_probe = ProbeDefinition.find(params[:id])

    respond_to do |format|
      if @custom_probe.update_attributes(params[:custom_probe])
        flash[:notice] = 'ProbeDefinition was successfully updated.'
        format.html { redirect_to(custom_probe_url(@custom_probe)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @custom_probe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_probes/1
  # DELETE /custom_probes/1.xml
  def destroy
    @custom_probe = ProbeDefinition.find(params[:id])
    @custom_probe.destroy

    respond_to do |format|
      format.html { redirect_to(custom_probes_url) }
      format.xml  { head :ok }
    end
  end
end
