class InterventionBuilder::GoalsController < ApplicationController
  additional_write_actions :regenerate_intervention_pdfs, :interventions_without_recommended_monitors
  helper_method :move_path

  def regenerate_intervention_pdfs
    CreateInterventionPdfs.generate(current_district)
    redirect_to :back
  end

  def interventions_without_recommended_monitors
    @int_defs = InterventionDefinition.find(:all,:include => [:recommended_monitors,{:intervention_cluster=>{:objective_definition=>:goal_definition}}], :conditions => ["recommended_monitors.id is null and goal_definitions.district_id = ?", current_district.id])
  end

  # GET /goal_definitions
  def index
    @goal_definitions = current_district.goal_definitions

    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /goal_definitions/1
  def show
    @goal_definition = current_district.goal_definitions.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
    end
  end

  # GET /goal_definitions/new
  def new
    @goal_definition = current_district.goal_definitions.build
  end

  # GET /goal_definitions/1;edit
  def edit
    @goal_definition = current_district.goal_definitions.find(params[:id])
  end

  # POST /goal_definitions
  def create
    @goal_definition = current_district.goal_definitions.build(params[:goal_definition])
    

    respond_to do |format|
      if @goal_definition.save
        flash[:notice] = 'Goal was successfully created.'
        format.html { redirect_to intervention_builder_goals_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /goal_definitions/1
  def update
    @goal_definition = current_district.goal_definitions.find(params[:id])
    @goal_definition.attributes=params[:goal_definition]

    respond_to do |format|
      if @goal_definition.save
        #update_attributes(params[:goal_definition])
        flash[:notice] = 'Goal was successfully updated.'
        format.html { redirect_to intervention_builder_goals_url }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /goal_definitions/1
  def destroy
    @goal_definition = current_district.goal_definitions.find(params[:id])
    if @goal_definition.objective_definitions.any?
      flash[:notice]="Objective Assigned, please remove them first"
    else
      @goal_definition.destroy
    end

    respond_to do |format|
      format.html { redirect_to intervention_builder_goals_url }
    end
  end

  def disable
    @goal_definition = current_district.goal_definitions.find(params[:id])
    if params[:enable]
      @goal_definition.update_attribute(:disabled,false)
    else
      @goal_definition.disable!
    end
    respond_to do |format|
      format.html { redirect_to intervention_builder_goals_url }
    end
  end



  def move
    @goal_definition = current_district.goal_definitions.find(params[:id])

    if params[:direction]
      @goal_definition.move_higher if params[:direction].to_s == "up"
      @goal_definition.move_lower if params[:direction].to_s == "down"
    end
    respond_to do |format|
      format.html {redirect_to intervention_builder_goals_url}
      format.js {@goal_definitions=current_district.goal_definitions} 
    end
  end

  protected
    def move_path(obj,direction)
      move_intervention_builder_goal_path(obj,:direction=>direction)
    end

end
