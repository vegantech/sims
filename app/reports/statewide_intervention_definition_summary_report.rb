# Interventions report for system interventions (via builder) found in the menu
Ruport::Formatter::Template.create(:standard) do |format|
  format.page = { :layout => :landscape }
  format.text ={ :font_size => 10 }
end

class StatewideInterventionDefinitionSummaryReport < DefaultReport 
  stage :header, :body
  load_html_csv_text

  def setup
    self.data = StatewideInterventionDefinitionSummary.new(options)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StatewideInterventionDefinitionSummaryReport

    build :header do
      pad_bottom(10) do
      end
    end

    build :body do
      pdf_writer.start_page_numbering(350, 10, 8, :center, 'Page: <PAGENUM>')
      pdf_writer.font_size = 8
      render_grouping data.to_grouping, :table_format => {
        :column_options => {
          'Category' => {:width => 95},
          'Title' => {:width => 110},
          'Description' => {:width => 230},
          'Progress Monitors' => {:width => 115},
          'Duration / Frequency' => {:width => 68},
          'Links and Attachments' => {:width => 90},
          'Bus. Key' => {:width => 49}
        }
      }, :formatter => pdf_writer
    end
  end
end


class StatewideInterventionDefinitionSummary

  def initialize(options = {})
  end

  def to_table
    return unless defined? Ruport

    #group concat works well!
    eee= InterventionDefinition.connection.send(:select, 
    InterventionDefinition.send( :construct_finder_sql,{
     :group=>"intervention_definitions.title, intervention_clusters.title, objective_definitions.title, goal_definitions.title", 
     :select => "intervention_definitions.title, intervention_definitions.description, intervention_clusters.title as category, objective_definitions.title as objective, 
     goal_definitions.title as goal, concat(intervention_definitions.frequency_multiplier, ' - ',frequencies.title) as frequency, 
     concat(intervention_definitions.time_length_num,' - ',time_lengths.title) as duration,
     count(distinct goal_definitions.district_id) as count_of_districts, count(distinct interventions.id) as count_of_interventions,
     group_concat(distinct probe_definitions.title separator ', ' ) as progress_monitors,
     concat(tiers.position,' - ',tiers.title) as tier
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
    
    ", :order => "goal, objective, category, tier, title",
    :conditions => "intervention_definitions.custom=false and intervention_definitions.disabled=false"
                                                          }))
    t=Table :data => eee, :column_names => eee.first.keys
    t.reorder 'goal','objective','category','tier','title','description', 'frequency', 'duration', 'progress_monitors','count_of_districts', 'count_of_interventions'
  end

  def to_grouping
    if @group.present?
      return @group
    else
      @table ||= to_table
#      @group = Ruport::Data::Grouping(@table, :by => ['goal','objective'])
    end
  end
end
