class Interventions::Goals < Interventions::Picker
  extend ActiveModel::Naming

  def initialize(district, opts = {})
    @district = district
    @opts = opts
    parse_opts
    @goal_id = @opts[:goal_id]
  end

  def goals
    #always the enabled district goal definitions
    @goals ||= @district.goal_definitions.merge(for_dropdown)
  end

  def for_dropdown
    GoalDefinition.enabled
  end

  def id
    #1. passed into initializer
    #2. autopick if only one goal
    #3 invalid id doesn't matter here it just won't get picked
    #4 disabled goal id poses problems for next model
    goal.try(:id)
  end

  def goal
    @goal ||= find_or_only(goals,@goal_id)
  end

  def objectives
    Interventions::Objectives.new(@district, @opts.merge(:goal => id))
  end


  def parse_opts
    derived = Interventions::Definitions.find_by_id(@opts[:definition_id]) ||
      Interventions::Categories.find_by_id(@opts[:category_id]) ||
      Interventions::Objectives.find_by_id(@opts[:objective_id])
    @opts.merge!(derived) if derived
  end

  def blank?
    goals.blank?
  end
end
