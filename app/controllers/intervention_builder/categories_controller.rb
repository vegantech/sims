class InterventionBuilder::CategoriesController < ApplicationController
  helper_method :move_path
  
  # GET /intervention_clusters
  # GET /intervention_clusters.xml
  before_filter(:get_objective_definition)
  def index
    @intervention_clusters = @objective_definition.intervention_clusters.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @intervention_clusters.to_xml }
    end
  end

  # GET /intervention_clusters/1
  # GET /intervention_clusters/1.xml
  def show

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @intervention_cluster.to_xml }
    end
  end

  # GET /intervention_clusters/new
  def new
    @intervention_cluster = @objective_definition.intervention_clusters.build
  end

  # GET /intervention_clusters/1;edit
  def edit
  end

  # POST /intervention_clusters
  # POST /intervention_clusters.xml
  def create
    @intervention_cluster = @objective_definition.intervention_clusters.build(params[:intervention_cluster])

    respond_to do |format|
      if @intervention_cluster.save
        flash[:notice] = 'InterventionCluster was successfully created.'
        format.html { redirect_to intervention_builder_category_url(@goal_definition,@objective_definition,@intervention_cluster) }
        format.xml  { head :created, :location => intervention_builder_category_url(@intervention_cluster) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervention_cluster.errors.to_xml }
      end
    end
  end

  # PUT /intervention_clusters/1
  # PUT /intervention_clusters/1.xml
  def update

    respond_to do |format|
      if @intervention_cluster.update_attributes(params[:intervention_cluster])
        flash[:notice] = 'InterventionCluster was successfully updated.'
        format.html { redirect_to intervention_builder_category_url(@goal_definition,@objective_definition,@intervention_cluster) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervention_cluster.errors.to_xml }
      end
    end
  end

  # DELETE /intervention_clusters/1
  # DELETE /intervention_clusters/1.xml
  def destroy
    if @intervention_cluster.intervention_definitions.any?
      flash[:notice]= "Please remove intervention definitions first."
    else
      @intervention_cluster.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to intervention_builder_categories_url }
      format.xml  { head :ok }
    end
  end

  def disable
    @intervention_cluster.disable!
    
    respond_to do |format|
      format.html { redirect_to intervention_builder_categories_url }
      format.xml  { head :ok }
    end
  end

  def move
    @intervention_cluster = @objective_definition.intervention_clusters.find(params[:id])
    oldpos=@intervention_cluster.position
    if params[:direction]
      @intervention_cluster.move_higher if params[:direction].to_s == "up"
      @intervention_cluster.move_lower if params[:direction].to_s == "down"
    end
    respond_to do |format|
      format.html {redirect_to index_url}
      format.js {@intervention_clusters=@objective_definition.intervention_clusters} 
    end
  end


  private
  def get_objective_definition
    @goal_definition = current_district.goal_definitions.find(params[:goal_id])
    @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id])
    @intervention_cluster = @objective_definition.intervention_clusters.find(params[:id]) if params[:id]
  end

  def move_path(item, direction)
    move_intervention_builder_category_path(:id=>item,:direction=>direction)
  end

  

end
