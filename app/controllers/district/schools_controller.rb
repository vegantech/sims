class District::SchoolsController < ApplicationController
  # GET /district_schools
  # GET /district_schools.xml
  def index
    @schools = current_district.schools.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end

  # GET /district_schools/1
  # GET /district_schools/1.xml
  def show
    @school = current_district.schools.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /district_schools/new
  # GET /district_schools/new.xml
  def new
    @school = current_district.schools.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /district_schools/1/edit
  def edit
    @school = current_district.schools.find(params[:id])
  end

  # POST /district_schools
  # POST /district_schools.xml
  def create
    @school = current_district.schools.build(params[:schools])

    respond_to do |format|
      if @school.save
        flash[:notice] = 'current_district.schools was successfully created.'
        format.html { redirect_to(district_school_url(@school)) }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /district_schools/1
  # PUT /district_schools/1.xml
  def update
    @school = current_district.schools.find(params[:id])

    respond_to do |format|
      if @school.update_attributes(params[:schools])
        flash[:notice] = 'current_district.schools was successfully updated.'
        format.html { redirect_to(district_school_url(@school)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /district_schools/1
  # DELETE /district_schools/1.xml
  def destroy
    @school = current_district.schools.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(district_schools_url) }
      format.xml  { head :ok }
    end
  end
end
