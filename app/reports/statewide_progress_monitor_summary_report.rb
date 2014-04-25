class StatewideProgressMonitorSummaryReport
  def setup
    self.data = StatewideProgressMonitorSummary.new(options)
  end
end


class StatewideProgressMonitorSummary

  def initialize(options = {})
  end

  def to_table

    #group concat works well!
    eee = ProbeDefinition.connection.send(:select,
    ProbeDefinition.send( :construct_finder_sql,{
      group: "probe_definitions.title",
      select: "probe_definitions.title as Title, probe_definitions.minimum_score"\
        "as 'Min Score', probe_definitions.maximum_score as 'Max Score', "\
        "probe_definitions.description as Description, group_concat(distinct"\
        "intervention_definitions.title separator ', ' ) as Interventions,"\
        "count(distinct probe_definitions.district_id) as 'Districts' ,"\
        "count(distinct probes.id) as 'Scores'",
#      count(interventions.id) as count_of_interventions,
      joins: "
        left outer join recommended_monitors on recommended_monitors"\
          ".probe_definition_id = probe_definitions.id
        left join intervention_definitions on recommended_monitors"\
          ".probe_definition_id = intervention_definitions.id
        left outer join intervention_probe_assignments on probe_definitions.id "\
          "= intervention_probe_assignments.probe_definition_id
        left outer join probes on probes.intervention_probe_assignment_id = "\
         "intervention_probe_assignments.id",
      order: "Title",
      conditions: 
        "probe_definitions.active = true and probe_definitions.custom = false"
    }))
    t = Table data: eee, column_names: eee.first.keys
    t.reorder 'Title','Description', 'Min Score', 'Max Score', 'Interventions','Districts', 'Scores'
  end

  def to_grouping
    if @group.present?
      return @group
    else

      @table ||= to_table
    end
  end
end
