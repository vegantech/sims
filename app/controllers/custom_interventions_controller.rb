class CustomInterventionsController < InterventionsController
  def new
    @tiers = current_district.tiers
    params[:custom]=true
    super
  end


  def create
    params["intervention"]["intervention_probe_assignment"]["probe_definition_attributes"].merge! params["probe_definition"] if params["probe_definition"]
    params[:intervention][:comment_author] = current_user.id

    @intervention = build_from_session_and_params

    if @intervention.save
      flash[:notice] = "Intervention was successfully created. #{@intervention.autoassign_message} "
      redirect_to(student_url(current_student, :tn=>0, :ep=>0))
    else
      raise @intervention.intervention_participants.collect(&:errors).inspect
      raise "intervention invalid #{@intervention.errors.inspect}" unless @intervention.valid?
      raise "intervention definition invalid" unless @intervention.intervention_definition.valid?

      @tiers = current_district.tiers
      @users = ([nil] | current_school.assigned_users.collect{|e| [e.fullname, e.id]})
      @recommended_monitors=@intervention.try(:recommended_monitors) || []
      puts @intervention.inspect
      #raise @intervention.errors.inspect
      @picker = Interventions::Goals.new(current_district,merged_params_and_values_from_session)
      # This is to make validation work
=begin      i = @intervention
      @intervention_comment = @intervention.comments.first
      @goal_definition = @intervention.goal_definition
      @objective_definition=@intervention.objective_definition
      @intervention_cluster = @intervention.intervention_cluster
      @intervention_definition = @intervention.intervention_definition
      populate_goals
      @intervention_probe_assignment.valid? if @intervention_probe_assignment #So errors show up on creation  TODO REFACTOR
      @intervention = i
      # end code to make validation work
=end
      render :action => "new"
    end
  end

  private

  def new_path(*args)
    new_custom_intervention_path(*args)
  end

  def populate_definitions
    find_intervention_definition
    @intervention_definition = @intervention_cluster.intervention_definitions.build(:custom=>true) if @intervention_cluster
    populate_intervention if @intervention_definition
  end

  def build_from_session_and_params
    params[:intervention] ||= {}
    @intervention = CustomIntervention.new(params[:intervention].merge(values_from_session))
    @intervention_probe_assignment = @intervention.intervention_probe_assignment if @intervention.intervention_probe_assignment
    @intervention
  end

  def values_from_session
    super.merge(:student_id => current_student.id)
  end

  def create_path
    custom_interventions_path
  end
end
