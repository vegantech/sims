module PopulateInterventionDropdowns
protected
  def values_from_session
    { :user_id => session[:user_id],
      :selected_ids => selected_students_ids
    }
  end

  def build_from_session_and_params
    params[:intervention] ||={}
    @intervention = current_student.interventions.build_and_initialize(params[:intervention].merge(values_from_session))
  end

  def populate_dropdowns
    @goal_definitions=current_district.goal_definitions
    if @intervention.intervention_definition
      @goal_definition=@goal_definitions.find(@intervention.goal_definition.id)
      @objective_definitions=@goal_definition.objective_definitions
      @objective_definition = @objective_definitions.find(@intervention.objective_definition.id)
      @intervention_clusters = @objective_definition.intervention_clusters
      @intervention_cluster = @intervention_clusters.find(@intervention.intervention_cluster.id)
      @intervention_definitions = @intervention_cluster.intervention_definitions
      @intervention_definition = @intervention_definitions.find(@intervention.intervention_definition.id)
      
    end


  end

  def populate_objectives
    @goal_definition= current_district.goal_definitions.find(params[:goal_definition][:id])
    @objective_definitions = @goal_definition.objective_definitions
  end

end
