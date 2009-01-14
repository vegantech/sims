require 'fileutils'
class CreateInterventionPdfs
  def self.generate(d)
    d.objective_definitions.each do |o| 
      dir= "public/generated_docs/#{d.id}/"
      FileUtils.makedir unless File.exists?dir
      File.open(dir+"#{o.title.split(" ").join("_")}.pdf",'w') do |f|
        f<< InterventionDefinitionSummaryReport.render_pdf(:objective_definition=>o, :template => :standard)
      end
      File.open(dir+"#{o.title.split(" ").join("_")}.html",'w') do |f|
        f<< InterventionDefinitionSummaryReport.render_html(:objective_definition=>o, :template => :standard)
      end
    end
  end
end
