class ProbesController < ApplicationController
  # GET /probes
  # GET /probes.xml
  def index
    @probes = Probe.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @probes }
    end
  end

  # GET /probes/1
  # GET /probes/1.xml
  def show
    @probe = Probe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @probe }
    end
  end

  # GET /probes/new
  # GET /probes/new.xml
  def new
    @probe = Probe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @probe }
    end
  end

  # GET /probes/1/edit
  def edit
    @probe = Probe.find(params[:id])
  end

  # POST /probes
  # POST /probes.xml
  def create
    @probe = Probe.new(params[:probe])

    respond_to do |format|
      if @probe.save
        flash[:notice] = 'Probe was successfully created.'
        format.html { redirect_to(@probe) }
        format.xml  { render :xml => @probe, :status => :created, :location => @probe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @probe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /probes/1
  # PUT /probes/1.xml
  def update
    @probe = Probe.find(params[:id])

    respond_to do |format|
      if @probe.update_attributes(params[:probe])
        flash[:notice] = 'Probe was successfully updated.'
        format.html { redirect_to(@probe) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @probe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /probes/1
  # DELETE /probes/1.xml
  def destroy
    @probe = Probe.find(params[:id])
    @probe.destroy

    respond_to do |format|
      format.html { redirect_to(probes_url) }
      format.xml  { head :ok }
    end
  end
end
