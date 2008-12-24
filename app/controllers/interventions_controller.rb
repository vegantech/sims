class InterventionsController < ApplicationController
  additional_write_actions 'end', 'quicklist'



  include PopulateInterventionDropdowns
  # GET /interventions/1
  # GET /interventions/1.xml
  def show
    @intervention = current_student.interventions.find(params[:id])

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
    respond_to do |format|
      format.html { populate_goals }# new.html.erb
      format.xml  { render :xml => @intervention }
    end
  end

  # GET /interventions/1/edit
  def edit
    @intervention = current_student.interventions.find(params[:id])
  end

  # POST /interventions
  # POST /interventions.xml
  def create
    @intervention= build_from_session_and_params


    respond_to do |format|
      if @intervention.save
        flash[:notice] = 'Intervention was successfully created. '+ @intervention.autoassign_message
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
    @intervention = current_student.interventions.find(params[:id])

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
    @intervention = current_student.interventions.find(params[:id])
    @intervention.destroy

    respond_to do |format|
      format.html { redirect_to(current_student) }
      format.xml  { head :ok }
    end
  end

  def end
    @intervention = current_student.interventions.find(params[:id])
    @intervention.end(current_user.id)
     respond_to do |format|
      format.html { redirect_to(current_student) }
      format.xml  { head :ok }
    end
  end

  def quicklist
    #FIXME scope this somehow
    @intervention_definition = InterventionDefinition.find(params[:quicklist_item][:intervention_definition_id])
    @intervention_cluster = @intervention_definition.intervention_cluster
    @objective_definition = @intervention_cluster.objective_definition
    @goal_definition = @objective_definition.goal_definition
    redirect_to new_intervention_url(:goal_id=>@goal_definition,:objective_id=>@objective_definition,
                                                    :category_id=>@intervention_cluster,:definition_id=>@intervention_definition)
  end
  
end



class Interventions::DefinitionsController < ApplicationController
  include PopulateInterventionDropdowns
 
  def index
    flash.keep(:custom_intervention)
    populate_goals
  end

  
  def select
    flash.keep(:custom_intervention)
    respond_to do |format|
      redirect_to new_intervention_url(:goal_id=>params[:goal_id],:objective_id=>params[:objective_id],
                                                    :category_id=>params[:category_id],:definition_id=>params[:intervention_definition][:id])
      format.js {
        populate_intervention
     }
    end
  end

end


