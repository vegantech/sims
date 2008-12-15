class DistrictsController < ApplicationController
  additional_write_actions :reset_password, :recreate_admin
  # GET /districts
  # GET /districts.xml
  def index
    @state = current_district.state
    @districts = @state.districts.normal

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @districts }
    end
  end

  # GET /districts/new
  # GET /districts/new.xml
  def new
    @district = District.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @district }
    end
  end

  # GET /districts/1/edit
  def edit
    @district = current_district
  end

  # POST /districts
  # POST /districts.xml
  def create
    @district = current_district.state.districts.normal.build(params[:district])

    respond_to do |format|
      if @district.save
        flash[:notice] = 'District was successfully created.'
        format.html { redirect_to(districts_url)}
        format.xml  { render :xml => @district, :status => :created, :location => @district }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @district.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /districts/1
  # PUT /districts/1.xml
  def update
    @district = current_district

    respond_to do |format|
      if @district.update_attributes(params[:district])
        flash[:notice] = 'District was successfully updated.'
        format.html { redirect_to(root_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @district.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /districts/1
  # DELETE /districts/1.xml
  def destroy
    @district = current_district.state.districts.normal.find(params[:id])
    @district.destroy
    flash[:notice] = @district.errors[:base]

    respond_to do |format|
      format.html { redirect_to(districts_url) }
      format.xml  { head :ok }
    end
  end
  
  def reset_password
    @district=District.find(params[:id])
    flash[:notice]= @district.reset_admin_password!
    redirect_to(districts_url)
  end

  def recreate_admin
    @district=District.find(params[:id])
    flash[:notice]= @district.recreate_admin!
    redirect_to(districts_url)
  end

end
