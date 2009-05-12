class TiersController < ApplicationController
  include SpellCheck
  helper_method :move_path

  # GET /tiers
  # GET /tiers.xml
  def index
    @tiers = current_district.tiers.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tiers }
    end
  end

  # GET /tiers/1
  # GET /tiers/1.xml
  def show
    @tier = current_district.tiers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tier }
    end
  end

  # GET /tiers/new
  # GET /tiers/new.xml
  def new
    @tier = current_district.tiers.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tier }
    end
  end

  # GET /tiers/1/edit
  def edit
    @tier = current_district.tiers.find(params[:id])
  end

  # POST /tiers
  # POST /tiers.xml
  def create
    @tier = current_district.tiers.build(params[:tier])
    spellcheck @tier.title and render :action=>:new and return unless params[:spellcheck].blank?


    respond_to do |format|
      if @tier.save
        flash[:notice] = 'Tier was successfully created.'
        format.html { redirect_to tiers_url }
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
    @tier = current_district.tiers.find(params[:id])
    @tier.attributes=params[:tier]

    spellcheck @tier.title and render :action=>:edit and return unless params[:spellcheck].blank?
  
    respond_to do |format|
      if @tier.save
        flash[:notice] = 'Tier was successfully updated.'
        format.html { redirect_to tiers_url }
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
    @tier = current_district.tiers.find(params[:id])
    @tier.destroy

    respond_to do |format|
      format.html { redirect_to(tiers_url) }
      format.xml  { head :ok }
    end
  end

  def move
    @tier = current_district.tiers.find(params[:id])

    if params[:direction]
      @tier.move_higher if params[:direction].to_s == "up"
      @tier.move_lower if params[:direction].to_s == "down"
    end
    respond_to do |format|
      format.html {redirect_to tiers_url}
      format.js {@tiers=current_district.tiers}
    end
  end

 protected
  def move_path(obj,direction)
    move_tier_path(obj,:direction=>direction)
  end

end
