class InterventionBuilder::InterventionsController < ApplicationController
  before_filter(:get_intervention_cluster)
  helper_method :move_path
  # GET /intervention_definitions
  def index
    @intervention_definitions = @intervention_cluster.intervention_definitions

    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /intervention_definitions/1
  def show

    respond_to do |format|
      format.html # show.rhtml
    end
  end

  # GET /intervention_definitions/new
  def new
    @intervention_definition = @intervention_cluster.intervention_definitions.build
    @intervention_definition.assets.build
  end

  # GET /intervention_definitions/1;edit
  def edit
    @intervention_clusters = current_district.intervention_clusters
  end

  # POST /intervention_definitions
  def create
    @intervention_definition = @intervention_cluster.intervention_definitions.build(params[:intervention_definition])

    respond_to do |format|
      if @intervention_definition.save
        flash[:notice] = 'InterventionDefinition was successfully created.'
        format.html { redirect_to intervention_builder_intervention_url(@goal_definition,@objective_definition,@intervention_cluster,@intervention_definition) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /intervention_definitions/1
  def update

    respond_to do |format|
      if @intervention_definition.update_attributes(params[:intervention_definition])
        flash[:notice] = 'InterventionDefinition was successfully updated.'
        @intervention_cluster,@objective_definition,@goal_definition = @intervention_definition.intervention_cluster,@intervention_definition.intervention_cluster.objective_definition,@intervention_definition.intervention_cluster.objective_definition.goal_definition if @intervention_cluster != @intervention_definition.intervention_cluster
        format.html { redirect_to intervention_builder_intervention_url(@goal_definition,@objective_definition,@intervention_cluster,@intervention_definition) }
      else
        format.html { edit;render :action => "edit" }
      end
    end
  end

  # DELETE /intervention_definitions/1
  def destroy
    if @intervention_definition.interventions.any?
      flash[:notice]= "Interventions exist for this intervention definition"
    else
      @intervention_definition.destroy
    end

    respond_to do |format|
      format.html { redirect_to intervention_builder_interventions_url }
    end
  end

  def disable
    @intervention_definition = InterventionDefinition.find(params[:id])
    @intervention_definition.disable!

    respond_to do |format|
      format.html { redirect_to intervention_builder_interventions_url }
    end
  end



  
  def move
    @intervention_definition = @intervention_cluster.intervention_definitions.find(params[:id])

    if params[:direction]
      @intervention_definition.move_higher if params[:direction].to_s == "up"
      @intervention_definition.move_lower if params[:direction].to_s == "down"
    end
    respond_to do |format|
      format.html {redirect_to index_url}
      format.js {@intervention_definitions=@intervention_cluster.intervention_definitions} 
    end
  end





  
  private
  def get_intervention_cluster
    @goal_definition = current_district.goal_definitions.find(params[:goal_id])
    @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id])
    @intervention_cluster = @objective_definition.intervention_clusters.find(params[:category_id])
    @intervention_definition=@intervention_cluster.intervention_definitions.find(params[:id]) if params[:id]
  end


  def move_path(item, direction)
    unless action_name=="show"
      move_intervention_builder_intervention_path(:id=>item,:direction=>direction)
    else
      url_for(:controller=>"recommended_monitors",:action=>:move,:direction=>direction,:id=>item)
    end
  end
  

end
