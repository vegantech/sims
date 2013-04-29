class Interventions::Goals < Interventions::Picker
  extend ActiveModel::Naming

  def initialize(*args)
    super(*args)
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
    Interventions::Objectives.new(object, @opts)
  end

  def parse_opts
    derived = Interventions::Definitions.find_by_id(@opts[:definition_id]) ||
      Interventions::Categories.find_by_id(@opts[:category_id]) ||
      Interventions::Objectives.find_by_id(@opts[:objective_id])
    puts derived
    @opts.merge!(derived) if derived
    @object_id ||= @opts[:goal_id]
  end

  def for_js
    case
    when @opts[:definition_id] && @opts[:custom].blank?
      objectives.categories.definitions
    when @opts[:category_id]
      objectives.categories
    when @opts[:objective_id]
      objectives
    else
      self
    end
  end


end
