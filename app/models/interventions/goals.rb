class Interventions::Goals < Interventions::Picker
  extend ActiveModel::Naming

  def initialize(*args)
    super
    parse_opts
  end

  def object_id_field
    :goal_id
  end

  def dropdowns
    @dropdowns ||= @parent.goal_definitions.merge(for_dropdown)
  end

  def for_dropdown
    GoalDefinition.enabled
  end

  def objectives
    Interventions::Objectives.new(@object, @opts)
  end

  def parse_opts
    derived = Interventions::Definitions.find_by_id(@opts[:definition_id]) ||
      Interventions::Categories.find_by_id(@opts[:category_id]) ||
      Interventions::Objectives.find_by_id(@opts[:objective_id])
    @opts.merge!(derived) if derived
    @object_id ||= @opts[:goal_id]
  end

end
