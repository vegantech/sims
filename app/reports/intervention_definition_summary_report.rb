# Interventions report for system interventions (via builder) found in the menu
Ruport::Formatter::Template.create(:standard) do |format|
  format.page = { :layout => :landscape }
  format.text ={ :font_size => 10 }
end

class InterventionDefinitionSummaryReport < DefaultReport 
  stage :header, :body, :footer
  required_option :objective_definition
  load_html_csv_text

  def setup
    self.data = InterventionDefinitionSummary.new(options)
  end

  class HTML < Ruport::Formatter::HTML
    renders :html, :for => InterventionDefinitionSummaryReport
    build :header do
      output << "<html><head>"
      output << '<style type="text/css">i {color:blue}</style>'
      output << "</head><body>"
      output << "Report Generated at #{Time.now.to_s(:long)}"
    end

    build :body do
      output << data.to_grouping.to_html
    end

    build :footer do
      output << "</body></html>"
    end
  end




  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => InterventionDefinitionSummaryReport

    build :header do
      pad_bottom(10) do
        add_text ObjectiveDefinition.find(options.objective_definition).title, :justification => :center
      end
    end

    build :body do
      ::PDF::Writer::TagAlink.style={:factor=>0.05, :text_color=>Color::RGB::Blue, :draw_line=>false, :line_style=>{:dash=>{:phase=>0, :pattern=>[]}}, :color=>Color::RGB::Blue}
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
      ::PDF::Writer::TagAlink.style=nil
    end
  end
end


class InterventionDefinitionSummary

  def initialize(options = {})
    @obj = ObjectiveDefinition.find options[:objective_definition]
    @group = options[:group]
  end

  def to_table
    return unless defined? Ruport

    
    a = InterventionDefinition.report_table(:all,
      :conditions => ["intervention_clusters.objective_definition_id = ? and custom = ? and (intervention_definitions.disabled = ?
          or intervention_definitions.disabled is null )", @obj, false, false],
      :include => {:tier=>{:only => ""}, :time_length => {:only => ""}, :frequency => {:only => ""} ,
        :intervention_cluster => {:only => 'title', :include => {:objective_definition=>{:only => "",:include => {:goal_definition =>{:only => ""}}}}}},
        :only => [],
      :methods => ['description_with_sld','bolded_title', 'frequency_duration_summary', 'tier_summary', 'monitor_summary', 'business_key', 'links_and_attachments','sld?'])

    if a.column_names.present?
      a.rename_columns(a.column_names,['Progress Monitors', 'Duration / Frequency','Tier', 'Bus. Key', 'Links and Attachments', 'Title','sld?','Description', 'Category'])
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
