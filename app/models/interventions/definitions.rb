class Interventions::Definitions < Interventions::Picker
  extend ActiveModel::Naming

  def object_id_field
    :definition_id
  end

  def dropdowns
    @definitions ||= @parent.intervention_definitions.for_dropdown(*for_dropdown) if @parent && @opts[:custom].blank?
  end

  def for_dropdown
    [@opts[:current_student].max_tier, @opts[:current_district], @opts[:school_id], @opts[:current_user]]
  end

  def self.find_by_id(id)
    if id
      o= InterventionDefinition.enabled.find_by_id(id)
      {:goal_id => o.objective_definition.goal_definition_id,
      :objective_id => o.objective_definition_id,
      :category_id => o.intervention_cluster_id } if o
    end
  end
end
