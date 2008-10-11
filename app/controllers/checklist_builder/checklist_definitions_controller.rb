class ChecklistDefinitionsController < ApplicationController
  helper ChecklistsHelper
  before_filter :authorize,:show_options
  skip_before_filter :authorize, :only=>:preview

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
    1.upto(3) do |i|
      @checklist_definition.minimum_scores.build(:tier => i,
      :score => i,
      :kind => 'average')
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @checklist_definition = current_district.checklist_definitions.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @checklist_definition = current_district.checklist_definitions.build(params[:checklist_definition])
    params[:minimum_score].each_value do |minimum_score|
      @checklist_definition.minimum_scores.build(minimum_score)
    end

    respond_to do |format|
      if @checklist_definition.save
        flash[:notice] = 'Checklist Definition was successfully created.'
        format.html do
          redirect_to checklist_definition_url(@checklist_definition)
        end
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  def update
    @checklist_definition = current_district.checklist_definitions.find(params[:id])
    @checklist_definition.attributes = params[:checklist_definition]

    @checklist_definition.minimum_scores.each do |minimum_score|
      minimum_score.attributes = params[:minimum_score][minimum_score.minimum_score_id.to_s]
    end

    respond_to do |format|
      if @checklist_definition.valid? and
        @checklist_definition.minimum_scores.all?(&:valid?)
        @checklist_definition.save!
        @checklist_definition.minimum_scores.each(&:save!)
        flash[:notice] = 'Checklist Definition was successfully updated.'
        format.html do
          redirect_to checklist_definition_url(@checklist_definition)
        end
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  def destroy
    @checklist_definition = current_district.checklist_definitions.find(params[:id])
    @checklist_definition.destroy
    respond_to do |format|
      format.html { redirect_to checklist_definitions_url }
      format.js
    end
  end

  def new_from_this
    @new_checklist_definition = current_district.checklist_definitions.new_from_existing(ChecklistDefinition.find(params[:id]))
    @new_checklist_definition.save_all!
    redirect_to checklist_definitions_url 
  end

  protected
  def show_options
    @checklist_definition_options = true
  end

end
