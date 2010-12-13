# Interventions report for system interventions (via builder) found in the menu
Ruport::Formatter::Template.create(:standard) do |format|
  format.page = { :layout => :landscape }
  format.text ={ :font_size => 10 }
end

class StatewideProgressMonitorSummaryReport < DefaultReport 
  stage :header, :body
  load_html_csv_text

  def setup
    self.data = StatewideProgressMonitorSummary.new(options)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StatewideProgressMonitorSummaryReport

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


class StatewideProgressMonitorSummary

  def initialize(options = {})
  end

  def to_table
    return unless defined? Ruport

    #group concat works well!
    eee= ProbeDefinition.connection.send(:select, 
    ProbeDefinition.send( :construct_finder_sql,{
     :group=>"probe_definitions.title", 
     :select => "probe_definitions.* ,
      group_concat(distinct intervention_definitions.title separator ', ' ) as interventions,
     count(probe_definitions.district_id) as count_of_districts 
     ",
#     count(interventions.id) as count_of_interventions,
     :joins => "
    left outer join recommended_monitors on recommended_monitors.probe_definition_id = probe_definitions.id
    left join intervention_definitions on recommended_monitors.probe_definition_id = intervention_definitions.id
    
    ", :order => "title",
    :conditions => "probe_definitions.active=true and probe_definitions.custom=false"
                                                          }))
    t=Table :data => eee, :column_names => eee.first.keys
#    t.reorder 'goal','objective','category','tier','title','description', 'frequency', 'duration', 'progress_monitors','count_of_districts', 'count_of_interventions'
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
