class Interventions::Objectives < Interventions::Picker
  extend ActiveModel::Naming

  #could be called with goal_id or objective_id
  #

  def object_id_field
    :objective_id
  end

  def dropdowns
    @objectives ||= @parent.objective_definitions.merge(for_dropdown) if @parent
  end

  def for_dropdown
    ObjectiveDefinition.enabled
  end

  def categories
    Interventions::Categories.new(object, @opts)
  end

  def self.find_by_id(id)
    if id
      o= ObjectiveDefinition.enabled.find_by_id(id)
      {:goal_id => o.goal_definition_id} if o
    end
  end
end
