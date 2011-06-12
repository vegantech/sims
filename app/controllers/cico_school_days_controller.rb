class CicoSchoolDaysController < ApplicationController
  # GET /cico_school_days
  # GET /cico_school_days.xml
  def index
    #use current date and render edit
    @cico_school_days = CicoSchoolDay.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cico_school_days }
    end
  end

  # GET /cico_school_days/1
  # GET /cico_school_days/1.xml
  def show
    @cico_school_day = CicoSchoolDay.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cico_school_day }
    end
  end

  # GET /cico_school_days/new
  # GET /cico_school_days/new.xml
  def new
    @cico_school_day = CicoSchoolDay.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cico_school_day }
    end
  end

  # GET /cico_school_days/1/edit
  def edit
    @cico_school_day = CicoSchoolDay.find(params[:id])
  end

  # POST /cico_school_days
  # POST /cico_school_days.xml
  def create
    @cico_school_day = CicoSchoolDay.new(params[:cico_school_day])

    respond_to do |format|
      if @cico_school_day.save
        flash[:notice] = 'CicoSchoolDay was successfully created.'
        format.html { redirect_to(@cico_school_day) }
        format.xml  { render :xml => @cico_school_day, :status => :created, :location => @cico_school_day }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cico_school_day.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cico_school_days/1
  # PUT /cico_school_days/1.xml
  def update
    @cico_school_day = CicoSchoolDay.find(params[:id])

    respond_to do |format|
      if @cico_school_day.update_attributes(params[:cico_school_day])
        flash[:notice] = 'CicoSchoolDay was successfully updated.'
        format.html { redirect_to(@cico_school_day) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cico_school_day.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cico_school_days/1
  # DELETE /cico_school_days/1.xml
  def destroy
    @cico_school_day = CicoSchoolDay.find(params[:id])
    @cico_school_day.destroy

    respond_to do |format|
      format.html { redirect_to(cico_school_days_url) }
      format.xml  { head :ok }
    end
  end
end
