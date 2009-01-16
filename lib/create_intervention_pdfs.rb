require 'fileutils'
class CreateInterventionPdfs
  def self.generate(district)
    district.objective_definitions.each do |o| 
      dir = "#{RAILS_ROOT}/public/district_generated_docs/#{district.id}/"
      FileUtils.mkdir_p dir unless File.exists? dir

      File.open(dir+"#{o.title.split(" ").join("_")}.pdf",'w') do |f|
        f << InterventionDefinitionSummaryReport.render_pdf(:objective_definition => o, :template => :standard)
      end

      File.open(dir+"#{o.title.split(" ").join("_")}.html",'w') do |f|
        f << InterventionDefinitionSummaryReport.render_html(:objective_definition => o, :template => :standard)
      end
    end
  end
end