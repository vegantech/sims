class CicoSettingsController < ApplicationController
  #needs to be restricted to school admin
  # GET /cico_settings
  # GET /cico_settings.xml
  def index
    @probe_definitions = current_district.probe_definitions.cico
    @cico_settings = CicoSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cico_settings }
    end
  end


  # GET /cico_settings/1/edit
  def edit
    @cico_setting = current_school.cico_settings.find_by_probe_definition_id(params[:id]) || 
      current_school.cico_settings.build(:probe_definition_id => params[:id])
  end

  # POST /cico_settings
  # POST /cico_settings.xml
  def create
    params[:id]=params[:cico_setting][:probe_definition_id]
    update
  end

  # PUT /cico_settings/1
  # PUT /cico_settings/1.xml
  def update
    @cico_setting = current_school.cico_settings.find_by_probe_definition_id(params[:id]) || 
      current_school.cico_settings.build(:probe_definition_id => params[:id])

    respond_to do |format|
      if @cico_setting.update_attributes(params[:cico_setting])
        flash[:notice] = 'CicoSetting was successfully updated.'
        format.html { redirect_to(cico_settings_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cico_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

end
