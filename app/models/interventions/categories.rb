class Interventions::Categories < Interventions::Picker
  extend ActiveModel::Naming

  def object_id_field
    :category_id
  end

  def dropdowns
    @categories ||= @parent.intervention_clusters.merge(for_dropdown) if @parent
  end

  def for_dropdown
    InterventionCluster.enabled
  end

  def definitions
    Interventions::Definitions.new(object, @opts)
  end

  def next
    @opts[:custom] ? custom_intervention : definitions
  end

  def custom_intervention
    CustomIntervention.new intervention_params.merge(:category => object)
  end

  def self.find_by_id(id)
    if id
      o= InterventionCluster.enabled.find_by_id(id)
      {:goal_id => o.objective_definition.goal_definition_id,
      :objective_id => o.objective_definition_id} if o
    end
  end

end
