class Interventions::Objectives < Interventions::Picker
  extend ActiveModel::Naming

  #could be called with goal_id or objective_id
  #

  def initialize(goal,opts={})
    @opts = opts
    @goal = goal
    @objective_id = @opts[:objective_id]
  end

  def objectives
    @objectives ||= @goal.objective_definitions.merge(for_dropdown)
  end

  def for_dropdown
    ObjectiveDefinition.enabled
  end

  def id
    #1. passed into initializer
    #2. autopick if only one goal
    #3 invalid id doesn't matter here it just won't get picked
    #4 disabled goal id poses problems for next model
    objective.try(:id)
  end

  def objective
    @objective ||= find_or_only(objectives,@objective_id)
  end

  def categories
    Interventions::Objectives.new(@objective, @opts)
  end

  def self.find_by_id(id)
    if id
      o= ObjectiveDefinition.enabled.find_by_id(id)
      {:goal_id => o.goal_definition_id} if o
    end
  end

  def blank?
    objectives.blank?
  end
end
