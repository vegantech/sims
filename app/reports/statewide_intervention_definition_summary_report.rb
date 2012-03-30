class StatewideInterventionDefinitionSummaryReport
  def setup
    self.data = StatewideInterventionDefinitionSummary.new(options)
  end
end


class StatewideInterventionDefinitionSummary

  def initialize(options = {})
  end

  def to_table

    #group concat works well!
    eee= InterventionDefinition.connection.send(:select,
    InterventionDefinition.send( :construct_finder_sql,{
     :group=>"intervention_definitions.title, intervention_clusters.title, objective_definitions.title, goal_definitions.title",
     :select => "intervention_definitions.title as Title, intervention_definitions.description as Description, intervention_clusters.title as Category,
     concat(intervention_definitions.frequency_multiplier, ' - ',frequencies.title) as Frequency,
     concat(intervention_definitions.time_length_num,' - ',time_lengths.title) as Duration,
     count(distinct goal_definitions.district_id) as 'Districts', count(distinct interventions.id) as 'In Use',
     group_concat(distinct probe_definitions.title separator ', ' ) as 'Progress Monitors',
     concat(tiers.position,' - ',tiers.title) as Tier,
     concat(goal_definitions.title, ' / ', objective_definitions.title) as 'Goal / Objective'

     ",
     :joins => "inner join intervention_clusters on intervention_clusters.id = intervention_definitions.intervention_cluster_id
    inner join objective_definitions on objective_definitions.id = intervention_clusters.objective_definition_id
    inner join goal_definitions on goal_definitions.id = objective_definitions.goal_definition_id
    inner join frequencies on frequencies.id = intervention_definitions.frequency_id
    inner join time_lengths on time_lengths.id = intervention_definitions.time_length_id
    inner join tiers on tiers.id = intervention_definitions.tier_id
    left outer join interventions on interventions.intervention_definition_id = intervention_definitions.id
    left outer join recommended_monitors on recommended_monitors.intervention_definition_id = intervention_definitions.id
    left join probe_definitions on recommended_monitors.probe_definition_id = probe_definitions.id

    ", :order => "'Goal / Objective', Category, Tier, Title",
    :conditions => "intervention_definitions.custom=false and intervention_definitions.disabled=false"
                                                          }))
    t=Table :data => eee, :column_names => eee.first.keys
    t.reorder 'Goal / Objective','Category','Tier','Title','Description', 'Frequency', 'Duration', 'Progress Monitors','Districts', 'In Use'
  end

  def to_grouping
    if @group.present?
      return @group
    else
      @table ||= to_table
      @group = @table #  Ruport::Data::Grouping(@table, :by => 'Goal / Objective')
    end
  end
end
