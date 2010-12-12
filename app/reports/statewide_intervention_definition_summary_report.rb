# Interventions report for system interventions (via builder) found in the menu
Ruport::Formatter::Template.create(:standard) do |format|
  format.page = { :layout => :landscape }
  format.text ={ :font_size => 10 }
end

class StatewideInterventionDefinitionSummaryReport < DefaultReport 
  stage :header, :body
  required_option :objective_definition
  load_html_csv_text

  def setup
    self.data = StatewideInterventionDefinitionSummary.new(options)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StatewideInterventionDefinitionSummaryReport

    build :header do
      pad_bottom(10) do
        add_text ObjectiveDefinition.find(options.objective_definition).title, :justification => :center
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
#    @obj = ObjectiveDefinition.find options[:objective_definition]
#    @group = options[:group]
  end

  def to_table
    return unless defined? Ruport

    #group concat works well!
    InterventionDefinition.find(:all,
     :group=>"intervention_definitions.title, intervention_clusters.title, objective_definitions.title, goal_definitions.title", 
     :select => "intervention_definitions.*,intervention_clusters.title as category, objective_definitions.title as objective, 
     goal_definitions.title as goal, frequencies.title as frequency_title, 
     time_lengths.title as time_length_title,count(goal_definitions.district_id) as count_of_districts, count(interventions.id) as count_of_interventions,
     group_concat(distinct probe_definitions.title separator ', ' ) as progress_monitors
     ",
     :joins => "inner join intervention_clusters on intervention_clusters.id = intervention_definitions.intervention_cluster_id
    inner join objective_definitions on objective_definitions.id = intervention_clusters.objective_definition_id
    inner join goal_definitions on goal_definitions.id = objective_definitions.goal_definition_id
    inner join frequencies on frequencies.id = intervention_definitions.frequency_id
    inner join time_lengths on time_lengths.id = intervention_definitions.time_length_id
    left outer join interventions on interventions.intervention_definition_id = intervention_definitions.id
    left outer join recommended_monitors on recommended_monitors.intervention_definition_id = intervention_definitions.id
    left join probe_definitions on recommended_monitors.probe_definition_id = probe_definitions.id
    
    ", :order => "goal, objective, category, title",
    :conditions => "intervention_definitions.custom=false and intervention_definitions.disabled=false"
                                                          )

    a = InterventionDefinition.report_table(:all,
      :conditions => ["intervention_clusters.objective_definition_id = ? and custom = ? and (intervention_definitions.disabled = ?
          or intervention_definitions.disabled is null )", @obj, false, false],
      :include => {:tier=>{:only => ""}, :time_length => {:only => ""}, :frequency => {:only => ""} ,
        :intervention_cluster => {:only => 'title', :include => {:objective_definition=>{:only => "",:include => {:goal_definition =>{:only => ""}}}}}},
      :only => [:description],
      :methods => ['bolded_title', 'frequency_duration_summary', 'tier_summary', 'monitor_summary', 'business_key', 'links_and_attachments'])
    if a.column_names.present?
      a.rename_columns(a.column_names,['Description', 'Progress Monitors', 'Duration / Frequency','Tier', 'Bus. Key', 'Links and Attachments', 'Title', 'Category'])
      a.reorder ['Bus. Key', 'Category', 'Title', 'Description', 'Tier', 'Duration / Frequency', 'Progress Monitors', 'Links and Attachments' ]
      a.sort_rows_by(['Tier', 'Category', 'Bus. Key'])
    else
      a.add_columns(['Bus. Key', 'Category', 'Title', 'Description', 'Tier', 'Duration / Frequency', 'Progress Monitors', 'Links and Attachments' ])
      
    end
  end

  def to_grouping
    if @group.present?
      return @group
    else
      @table ||= to_table
      @group = Ruport::Data::Grouping(@table, :by => 'Tier', :order => :name) 
    end
  end
end
