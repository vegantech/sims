class InterventionBuilder::ObjectivesController < InterventionBuilder::BaseController
  before_filter :get_goal_definition, :except => :suggestions

  # GET /objective_definitions
  def index
    @objective_definitions = @goal_definition.objective_definitions

    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /objective_definitions/1
  def show
    #@objective_definition populated by before filter
    respond_to do |format|
      format.html # show.rhtml
    end
  end

  # GET /objective_definitions/new
  def new
    @objective_definition = @goal_definition.objective_definitions.build
  end

  # GET /objective_definitions/1;edit
  def edit
    #@objective_definition populated by before filter
  end

  # POST /objective_definitions
  def create
    @objective_definition = @goal_definition.objective_definitions.build(params[:objective_definition])

    respond_to do |format|
      if @objective_definition.save
        flash[:notice] = 'Objective was successfully created.'
        format.html { redirect_to intervention_builder_objectives_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /objective_definitions/1
  def update
    @objective_definition.attributes=params[:objective_definition]

    respond_to do |format|
      if @objective_definition.save
        flash[:notice] = 'Objective was successfully updated.'
        format.html { redirect_to intervention_builder_objectives_url }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /objective_definitions/1
  def destroy

    if @objective_definition.intervention_clusters.any?
      flash[:notice]= "Intervention Categories, please remove them first"
    else
      @objective_definition.destroy
    end
    respond_to do |format|
      format.html { redirect_to intervention_builder_objectives_url }
    end
  end

  def disable
    if params[:enable]
      @objective_definition.update_attribute(:disabled, false)
    else
      @objective_definition.disable!
    end
    respond_to do |format|
      format.html { redirect_to intervention_builder_objectives_url }
    end
  end


  def move
    @objective_definition = @goal_definition.objective_definitions.find(params[:id])

    if params[:direction]
      @objective_definition.move_higher if params[:direction].to_s == "up"
      @objective_definition.move_lower if params[:direction].to_s == "down"
    end
    respond_to do |format|
      format.html {redirect_to :action => :index}
      format.js {@objective_definitions=@goal_definition.objective_definitions}
    end
  end


  private
  def get_goal_definition
    @goal_definition = current_district.goal_definitions.find(params[:goal_id])
    @objective_definition = @goal_definition.objective_definitions.find(params[:id]) if params[:id]
  end

  def move_path(item, direction)
    move_intervention_builder_objective_path(:id=>item,:direction=>direction)
  end

end
