class InterventionBuilder::GoalsController < ApplicationController
  #before_filter :authorize
  helper_method :move_path
  # GET /goal_definitions
  # GET /goal_definitions.xml
  def index
    @goal_definitions = current_district.goal_definitions

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @goal_definitions.to_xml }
    end
  end

  # GET /goal_definitions/1
  # GET /goal_definitions/1.xml
  def show
    @goal_definition = current_district.goal_definitions.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @goal_definition.to_xml }
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
  # POST /goal_definitions.xml
  def create
    @goal_definition = current_district.goal_definitions.build(params[:goal_definition])

    respond_to do |format|
      if @goal_definition.save
        flash[:notice] = 'Goal Definition was successfully created.'
        format.html { redirect_to intervention_builder_goal_url(@goal_definition) }
        format.xml  { head :created, :location => intervention_builder_goal_url(@goal_definition) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @goal_definition.errors.to_xml }
      end
    end
  end

  # PUT /goal_definitions/1
  # PUT /goal_definitions/1.xml
  def update
    @goal_definition = current_district.goal_definitions.find(params[:id])

    respond_to do |format|
      if @goal_definition.update_attributes(params[:goal_definition])
        flash[:notice] = 'Goal Definition was successfully updated.'
        format.html { redirect_to intervention_builder_goal_url(@goal_definition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @goal_definition.errors.to_xml }
      end
    end
  end

  # DELETE /goal_definitions/1
  # DELETE /goal_definitions/1.xml
  def destroy
    @goal_definition = current_district.goal_definitions.find(params[:id])
    if @goal_definition.objective_definitions.any?
      flash[:notice]="Objective Definitions Assigned, please remove them first"
    else
      @goal_definition.destroy
    end

    respond_to do |format|
      format.html { redirect_to intervention_builder_goals_url }
      format.xml  { head :ok }
    end
  end

  def disable
    @goal_definition = current_district.goal_definitions.find(params[:id])
    @goal_definition.disable!
    respond_to do |format|
      format.html { redirect_to intervention_builder_goals_url }
      format.xml  { head :ok }
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
