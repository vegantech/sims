require 'fileutils'
class CreateInterventionPdfs
  def self.generate(district)
      dir = "#{RAILS_ROOT}/public/system/district_generated_docs/#{district.id}/"
    old_files = Dir.glob("#{dir}*")
    new_files = []
    
    district.objective_definitions.each do |o| 
      FileUtils.mkdir_p dir unless File.exists? dir

      File.open(dir+"#{o.title.split(" ").join("_")}.pdf",'w') do |f|
        f << InterventionDefinitionSummaryReport.render_pdf(:objective_definition => o, :template => :standard)
      end

      File.open(dir+"#{o.title.split(" ").join("_")}.html",'w') do |f|
        f << InterventionDefinitionSummaryReport.render_html(:objective_definition => o, :template => :standard)
      end

      new_files << (dir+"#{o.title.split(" ").join("_")}.html")
      new_files << (dir+"#{o.title.split(" ").join("_")}.pdf")

      
    end
     FileUtils.rm(old_files - new_files)
  end
end
