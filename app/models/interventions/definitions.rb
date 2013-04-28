class Interventions::Definitions
  extend ActiveModel::Naming

  #could be called with goal_id or objective_id
  #

  def initialize(district,opts={})
    @district = district
    @opts = opts
    @goal_id = opts[:goal_id]

    @objective_id = @opts[:objective_id]
  end

  def objectives
    @objectives ||= @district.objective_definitions.for_dropdown.merge(Interventions::Goals.for_dropdown)
  end

  def for_dropdown
    ObjectiveDefinition.enabled
  end

  def id
    #1. passed into initializer
    #2. autopick if only one goal
    #3 invalid id doesn't matter here it just won't get picked
    #4 disabled goal id poses problems for next model
    @objective_id ||= only_objective_id
  end

  def only_objective_id
    objectivess.first.id if objectives.one?
  end

  def categories
    Interventions::Objectives.new(@district, @opts.merge(:objective_id => id))
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
