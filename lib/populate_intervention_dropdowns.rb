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
    @intervention = current_student.interventions.build_and_initialize(params[:intervention].merge(values_from_session))
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
    if params[:custom_intervention] == "true"
      @intervention_definition = @intervention_cluster.intervention_definitions.build(:custom=>true) if @intervention_cluster
      @tiers=current_district.tiers
    else
      @intervention_definitions = @intervention_cluster.intervention_definitions.for_dropdown(
        current_student.max_tier, current_district, current_school_id, current_user) if @intervention_cluster
    end
    populate_intervention if @intervention_definition
  end

  def populate_categories
    find_intervention_cluster
    @intervention_clusters = @objective_definition.intervention_clusters.enabled if @objective_definition
    populate_definitions if @intervention_cluster
  end

  def populate_objectives
    find_objective_definition
    @objective_definitions = @goal_definition.objective_definitions.enabled if @goal_definition
    populate_categories if @objective_definition
  end

  def populate_goals
    find_goal_definition
    @goal_definitions = current_district.goal_definitions.enabled # not for js
    populate_objectives if @goal_definition
  end

  def find_goal_definition
    @goal_definition ||=
      if params[:goal_id]
        current_district.goal_definitions.find_by_id(params[:goal_id])
      elsif current_district.goal_definitions.enabled.one?
        current_district.goal_definitions.first
      else
        nil
        # intervention definition provided
      end
  end

  def find_objective_definition
    find_goal_definition or return
    @objective_definition ||=
      if params[:objective_id]
        @goal_definition.objective_definitions.find_by_id(params[:objective_id])
      elsif @goal_definition.objective_definitions.enabled.one?
        @goal_definition.objective_definitions.first
      end
  end

  def find_intervention_cluster
    find_objective_definition or return
    @intervention_cluster ||=
      if params[:category_id]
        @objective_definition.intervention_clusters.find_by_id(params[:category_id])
      elsif @objective_definition.intervention_clusters.enabled.one?
        @objective_definition.intervention_clusters.first
      end
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
