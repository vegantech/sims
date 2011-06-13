class CicoSchoolDaysController < ApplicationController
  # GET /cico_school_days
  # GET /cico_school_days.xml
  def index
    #use current date and render edit
    params[:id]=Date.today.to_s
    edit
    render :action => 'edit'
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
    @cico_setting = current_school.cico_settings.find(params[:cico_setting_id])
    @cico_school_day = @cico_setting.cico_school_days.by_date_and_user(params[:id], current_user)

      @ipas=@cico_setting.intervention_probe_assignments(current_user)
      @students = @ipas.collect(&:student)
      @expectation_values = @cico_setting.expectation_values.collect{|e| [e,e]}

  end

  # POST /cico_school_days
  # POST /cico_school_days.xml
  def create
    params[:id]=params[:cico_school_day][:date]
    update
  end

  # PUT /cico_school_days/1
  # PUT /cico_school_days/1.xml
  def update
    @cico_setting = current_school.cico_settings.find(params[:cico_setting_id])
    @cico_school_day = @cico_setting.cico_school_days.find_by_date(params[:id]) || 
      @cico_setting.cico_school_days.build(:date => params[:id])

    respond_to do |format|
      if @cico_school_day.update_attributes(params[:cico_school_day])
        flash[:notice] = 'CicoSchoolDay was successfully updated.'
        format.html { redirect_to(:action => "edit") }
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
