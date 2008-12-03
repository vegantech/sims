module PopulateInterventionDropdowns
protected
  def values_from_session
    { :user_id => session[:user_id],
      :selected_ids => selected_students_ids,
      :school_id => session[:school_id]
    }
  end

  def build_from_session_and_params
    params[:intervention] ||={}
    @intervention = current_student.interventions.build_and_initialize(params[:intervention].merge(values_from_session))
  end

  def populate_intervention
    find_intervention_definition
    params[:intervention]||={}
    params[:intervention].merge!(:intervention_definition=>@intervention_definition)
    build_from_session_and_params
  end

  def populate_definitions
    find_intervention_definition
    unless flash[:custom_intervention] 
      @intervention_definitions=@intervention_cluster.intervention_definitions
    else
      @intervention_definition=@intervention_cluster.intervention_definitions.build
    end
    populate_intervention if @intervention_definition
  end


  def populate_categories
    find_intervention_cluster
    @intervention_clusters=@objective_definition.intervention_clusters
    populate_definitions if @intervention_cluster
  end

  def populate_objectives
    find_objective_definition
    @objective_definitions = @goal_definition.objective_definitions
    populate_categories if @objective_definition
  end

  def populate_goals
    find_goal_definition
    @goal_definitions=current_district.goal_definitions #not for js
    populate_objectives if @goal_definition
  end

  def find_goal_definition
    @goal_definition ||=
      if params[:goal_id] || (params[:goal_definition] && params[:goal_definition][:id])
        @goal_definition=current_district.goal_definitions.find(params[:goal_id] || params[:goal_definition][:id])
      elsif current_district.goal_definitions.size==1
        @goal_definition=current_district.goal_definitions.first
      elsif false 
        #intervention definition provided
      end
    end

  def find_objective_definition
    find_goal_definition
    @objective_definition ||= 
      if params[:objective_id] || (params[:objective_definition] && params[:objective_definition][:id])
          @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id] || params[:objective_definition][:id])
      elsif @goal_definition.objective_definitions.size==1
          @objective_definition=@goal_definition.objective_definitions.first
      end
  end

  def find_intervention_cluster
    find_objective_definition
    @intervention_cluster ||= 
      if params[:category_id] || (params[:intervention_cluster] && params[:intervention_cluster][:id])
          @intervention_cluster=@objective_definition.intervention_clusters.find(params[:category_id] || params[:intervention_cluster][:id])
      elsif @objective_definition.intervention_clusters.size==1
          @intervention_cluster=@objective_definition.intervention_clusters.first
      end
  end

  def find_intervention_definition
    find_intervention_cluster
    @intervention_definition ||= 
      if params[:definition_id] || (params[:intervention_definition] && params[:intervention_definition][:id])
          @intervention_definition=@intervention_cluster.intervention_definitions.find(params[:definition_id] || params[:intervention_definition][:id])
      elsif @intervention_cluster.intervention_definitions.size==1
          @intervention_definition=@intervention_cluster.intervention_definitions.first
      end
  end




  

end
