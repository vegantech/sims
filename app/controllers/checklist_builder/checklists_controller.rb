class ChecklistBuilder::ChecklistsController < ApplicationController
  def preview
    @checklist_definition = current_district.checklist_definitions.find(params[:id])
    @checklist=@checklist_definition.checklists.build
    @checklist.skip_cache=true

    respond_to do |format|
      format.html
    end
  end

  def index
    @checklist_definitions = current_district.checklist_definitions
    respond_to do |format|
      format.html
    end
  end

  def show
    @checklist_definition = current_district.checklist_definitions.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @checklist_definition = current_district.checklist_definitions.build

    respond_to do |format|
      format.html
#      format.js
    end
  end

  def edit
    @checklist_definition = current_district.checklist_definitions.find(params[:id])
    respond_to do |format|
      format.html
#      format.js
    end
  end

  def create
    @checklist_definition = current_district.checklist_definitions.build(params[:checklist_definition])

    @checklist_definitions = current_district.checklist_definitions
    respond_to do |format|
      if @checklist_definition.save
        flash[:notice] = 'Checklist Definition was successfully created.'
        format.html do
          redirect_to checklist_builder_checklist_url(@checklist_definition)
        end
#        format.js
      else
        format.html { render :action => "new" }
#        format.js
      end
    end
  end

  def update
    @checklist_definition = current_district.checklist_definitions.find(params[:id])
    @checklist_definition.attributes = params[:checklist_definition]


    respond_to do |format|
      if @checklist_definition.valid? and
        @checklist_definition.save!
        flash[:notice] = 'Checklist Definition was successfully updated.'
        format.html do
          redirect_to checklist_builder_checklist_url(@checklist_definition)
        end
#        format.js
      else
        format.html { render :action => "edit" }
#        format.js
      end
    end
  end

  def destroy
    @checklist_definition = current_district.checklist_definitions.find(params[:id])
    if @checklist_definition.checklists.blank?
      @checklist_definition.destroy
    else
      flash[:notice]= "Checklist definition is in use, please disable it instead"
    end

    @checklist_definitions = current_district.checklist_definitions
    respond_to do |format|
      format.html { redirect_to checklist_builder_checklists_url }
      format.js
    end
  end

  def new_from_this

    @old_checklist_definition = ChecklistDefinition.find(params[:id])
    districts=[current_district, current_district.admin_district].compact
    if districts.include?(@old_checklist_definition.district)
      @new_checklist_definition = @old_checklist_definition.deep_clone
      @new_checklist_definition.district = current_district
    end

    if @new_checklist_definition && @new_checklist_definition.save
      flash[:notice] = "Checklist Definition was successfully copied"
    else
      flash[:notice] = "Checklist Definition could not be copied"
    end

    redirect_to checklist_builder_checklists_url
  end
  private
  def jquery?
    false
  end
end
