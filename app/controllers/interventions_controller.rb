class InterventionsController < ApplicationController
  additional_write_actions 'end', 'quicklist', 'quicklist_options'
  before_filter :find_intervention, :only => [:show, :edit, :update, :end, :destroy]

  include PopulateInterventionDropdowns
  # GET /interventions/1
  # GET /interventions/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @intervention }
    end
  end

  # GET /interventions/new
  # GET /interventions/new.xml
  def new
    flash[:custom_intervention] = params[:custom_intervention]
    flash.keep(:custom_intervention)
    @quicklist=true if params[:quicklist]

    respond_to do |format|
      format.html { populate_goals }# new.html.erb
      format.xml  { render :xml => @intervention }
    end
  end

  # GET /interventions/1/edit
  def edit
  end

  # POST /interventions
  # POST /interventions.xml
  def create
    @intervention = build_from_session_and_params

    respond_to do |format|
      if @intervention.save
        flash[:notice] = 'Intervention was successfully created. '
        flash[:notice] += @intervention.autoassign_message if @intervention.autoassign_message
        format.html { redirect_to(current_student) }
        format.xml  { render :xml => @intervention, :status => :created, :location => @intervention }
      else
        format.html { render :action => "new",:intervention=>{:intervention_definition_id=>@intervention.intervention_definition_id }}
        format.xml  { render :xml => @intervention.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interventions/1
  # PUT /interventions/1.xml
  def update
    respond_to do |format|
      if @intervention.update_attributes(params[:intervention])
        flash[:notice] = 'Intervention was successfully updated.'
        format.html { redirect_to(current_student) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervention.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interventions/1
  # DELETE /interventions/1.xml
  def destroy
    @intervention.destroy

    respond_to do |format|
      format.html { redirect_to(current_student) }
      format.xml  { head :ok }
    end
  end

  def end
    @intervention.end(current_user.id)
     respond_to do |format|
      format.html { redirect_to(current_student) }
      format.xml  { head :ok }
    end
  end


  def quicklist_options
    @quicklist_intervention_definitions = current_school.quicklist 
    respond_to do |format|
      format.js
      format.html
    end
  end

  
  def quicklist #post
    
    #FIXME scope this somehow
    @intervention_definition = InterventionDefinition.find_by_id(params[:quicklist_item][:intervention_definition_id])
    redirect_to :back and return if @intervention_definition.blank?
    @intervention_cluster = @intervention_definition.intervention_cluster
    @objective_definition = @intervention_cluster.objective_definition
    @goal_definition = @objective_definition.goal_definition
    redirect_to new_intervention_url(:goal_id=>@goal_definition,:objective_id=>@objective_definition,
           :category_id=>@intervention_cluster,:definition_id=>@intervention_definition, :quicklist=>true)
  end

  private

  def find_intervention
    @intervention = current_student.interventions.find_by_id(params[:id])
    unless @intervention
      flash[:notice] = "Intervention could not be found"
      redirect_to current_student and return
    end
  end
end
