class TiersController < ApplicationController
  # GET /tiers
  # GET /tiers.xml
  def index
    @tiers = Tier.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tiers }
    end
  end

  # GET /tiers/1
  # GET /tiers/1.xml
  def show
    @tier = Tier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tier }
    end
  end

  # GET /tiers/new
  # GET /tiers/new.xml
  def new
    @tier = Tier.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tier }
    end
  end

  # GET /tiers/1/edit
  def edit
    @tier = Tier.find(params[:id])
  end

  # POST /tiers
  # POST /tiers.xml
  def create
    @tier = Tier.new(params[:tier])

    respond_to do |format|
      if @tier.save
        flash[:notice] = 'Tier was successfully created.'
        format.html { redirect_to(@tier) }
        format.xml  { render :xml => @tier, :status => :created, :location => @tier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tiers/1
  # PUT /tiers/1.xml
  def update
    @tier = Tier.find(params[:id])

    respond_to do |format|
      if @tier.update_attributes(params[:tier])
        flash[:notice] = 'Tier was successfully updated.'
        format.html { redirect_to(@tier) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tiers/1
  # DELETE /tiers/1.xml
  def destroy
    @tier = Tier.find(params[:id])
    @tier.destroy

    respond_to do |format|
      format.html { redirect_to(tiers_url) }
      format.xml  { head :ok }
    end
  end
end
