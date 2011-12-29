#this should generate an html file and pdf
require 'prawn'
class ObjectiveSummaryReport < Prawn::Document
  HEADERS = ["Bus. Key", "Category", "Title", "Description", "Duration/ Frequency", "Progress Monitors", "Links and Attachments"]
  METHODS = %w{business_key intervention_cluster title description frequency_duration_summary monitor_summary links_and_attachments}


  def initialize(objective_definition, base_path="")
    @objective_definition = objective_definition
    base_path = base_path
  end

  def generate
    gather_data
    generate_html
    generate_pdf
  end

  def gather_data
    #group by tier, order by category
    @tiers = @objective_definition.intervention_definitions.group_by(&:tier).sort
    self
  end

  def generate_html
    build_html
    save_html(build_html)
  end

  def build_html
    html = []
    html << "<html><head>"
    html << "<title>" + title + "</title>"
    html << "</head><body>"
    html << build_tier_html
    html << generated_at
    html << "</body></html>"
    html.join("\n")
  end

  def build_tier_html
    @tiers.collect do |tier, intervention_definitions|
      "<p>" + tier.to_s + "</p>" + "\n" +  intervention_definitions_html_table(intervention_definitions)
    end.join("\n")
  end

  def intervention_definitions_html_table(intervention_definitions)
    table = []
    table << "<table>"
    table << "<tr>"
    HEADERS.each do |h|
      table << "<th>#{h}</th>"
    end
    table << "</tr>"
    intervention_definitions.each do |id|
      table << "<tr>"
      METHODS.each { |m| table << "<td>#{id.send m}</td>" }
      table << "</tr>"
    end
    table << "</table>"
    table.join("\n")
  end


  def save_html(html)
  end

  def generated_at
    "Report Generated at #{Time.now.to_s(:long)}"
  end

  def build_tier_pdf(pdf)
    @tiers.collect do |tier, intervention_definitions|
      pdf.move_down 10
      pdf.text tier.to_s
      table = []
      table << HEADERS
      intervention_definitions.each do |id|
        table << METHODS.collect {|m| id.send(m).to_s}
      end
      pdf.table table, :header => true
      pdf.move_down 10
    end
  end

  def build_pdf
    pdf = Prawn::Document.new :page_layout => :landscape
    pdf.text title
    build_tier_pdf(pdf)
    pdf.text generated_at
    pdf
 end

  def save_pdf(pdf)
    #pdf.render_file filename.pdf
  end

  def generate_pdf
    save_pdf(build_pdf)
  end
  def title
    @objective_definition.title
  end
end
