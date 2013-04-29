module PopulateInterventionDropdowns
protected
  def values_from_session
    { :user_id => current_user.id,
      :selected_ids => selected_student_ids,
      :school_id => session[:school_id]
    }
  end

  def build_from_session_and_params
    params[:intervention] ||= {}
    @intervention = current_student.interventions.build(params[:intervention].merge(values_from_session))
    @intervention_probe_assignment = @intervention.intervention_probe_assignment if @intervention.intervention_probe_assignment
    @intervention
  end

  def populate_intervention
    return if params[:intervention_definition] and params[:intervention_definition][:id].blank?
    find_intervention_definition
    @recommended_monitors = @intervention_definition.recommended_monitors_with_custom.select(&:probe_definition)
    params[:intervention] ||= {}
    params[:intervention].merge!(:intervention_definition => @intervention_definition)
    build_from_session_and_params
    @users = [nil] | current_school.assigned_users.collect{|e| [e.fullname, e.id]}
  end

  def populate_definitions
    find_intervention_definition
    @intervention_definitions = @intervention_cluster.intervention_definitions.for_dropdown(
      current_student.max_tier, current_district, current_school_id, current_user) if @intervention_cluster
    populate_intervention if @intervention_definition
  end


  def find_intervention_definition
    find_intervention_cluster or return
    @intervention_definition ||= 
      if params[:definition_id] || (params[:intervention_definition] && params[:intervention_definition][:id])
        @intervention_cluster.intervention_definitions.find_by_id(params[:definition_id] || params[:intervention_definition][:id])
      elsif @intervention_cluster.intervention_definitions.enabled.one?
        @intervention_cluster.intervention_definitions.first
      end
  end
end
