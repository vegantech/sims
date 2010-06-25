class InterventionBuilder::InterventionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :disable
  additional_write_actions :sort
  before_filter(:get_intervention_cluster, :except=>:suggestions)
  helper_method :move_path
  # GET /intervention_definitions
  def index
    params[:enabled]=true and params[:commit]=true unless params[:commit]
    @intervention_definitions = @intervention_cluster.intervention_definitions

    #TODO Refactor filter and put in model
    if params[:commit]
      if params[:enabled] || params[:disabled]
        @intervention_definitions.reject!(&:disabled) unless params[:disabled]
        @intervention_definitions = @intervention_definitions.select(&:disabled) unless params[:enabled]
      end
      
      if params[:custom] || params[:system]
        @intervention_definitions.reject!(&:custom) unless params[:custom]
        @intervention_definitions = @intervention_definitions.select(&:custom) unless params[:system]
      end
    end

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
    @tiers = current_district.tiers
  end

  # GET /intervention_definitions/1;edit
  def edit
    @intervention_clusters = current_district.intervention_clusters
    @tiers = current_district.tiers
  end

  # POST /intervention_definitions
  def create
    @intervention_definition = @intervention_cluster.intervention_definitions.build(params[:intervention_definition])

    respond_to do |format|
      if @intervention_definition.save
        flash[:notice] = 'Intervention was successfully created.'
        format.html { redirect_to intervention_builder_interventions_url(@goal_definition,@objective_definition,@intervention_cluster) }
      else
        format.html {@tiers=current_district.tiers; render :action => "new" }
      end
    end
  end

  # PUT /intervention_definitions/1
  def update
    @intervention_definition.attributes=params[:intervention_definition]
    
    respond_to do |format|
      if @intervention_definition.save
        flash[:notice] = 'Intervention was successfully updated.'
        setup_parent_instance_variables
        format.html { redirect_to intervention_builder_interventions_url(@goal_definition,@objective_definition,@intervention_cluster) }
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
      format.html { redirect_to intervention_builder_interventions_url(@goal_definition,@objective_definition,@intervention_cluster) }
    end
  end

  def disable
    if params[:id]
      @intervention_definitions = Array(@intervention_definition)
    else
      @intervention_definitions = []
    end
    if params[:enable]
      a='enabled'
      @intervention_definitions.each{|i| i.update_attribute(:disabled, false)}
    else
      a='disabled'
      @intervention_definitions.each(&:disable!)
    end

    flash[:notice] = "#{@template.pluralize(@intervention_definitions.size, 'Intervention Definition')} #{a}."
    respond_to do |format|
      format.html { redirect_to intervention_builder_interventions_url(@goal_definition,@objective_definition,@intervention_cluster) }
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

  def sort
    params[:intervention_definition_list].each_with_index do |id, index|
      @intervention_cluster.intervention_definitions.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
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

  def setup_parent_instance_variables
        @intervention_cluster,@objective_definition,@goal_definition = @intervention_definition.intervention_cluster,@intervention_definition.intervention_cluster.objective_definition,@intervention_definition.intervention_cluster.objective_definition.goal_definition if @intervention_cluster != @intervention_definition.intervention_cluster
        @tiers=current_district.tiers
        true #meeded for spellcheck call
  end
end
