class CustomInterventionsController < InterventionsController
  def new
    @tiers = current_district.tiers
    params[:custom]=true
    super
  end


  def create
    @tiers = current_district.tiers
    params[:custom]=true
    params[:category_id] = params[:intervention][:intervention_definition_attributes][:intervention_cluster_id]
    super
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
