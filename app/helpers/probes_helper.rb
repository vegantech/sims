module ProbesHelper
  def probe_graph(intervention_probe_assignment, count)
    html = <<-"HTML"
        <p style="text-align:center;">
        
          Current scores for "#{intervention_probe_assignment.probe_definition.title}"<br />
    HTML

    intervention_probe_assignment.benchmarks.each do |benchmark|
    html += <<-"HTML"

          Benchmark: #{benchmark[:score]} at grade level #{benchmark[:grade_level]} <br />

    HTML
    end


    html+ "</p>" +
     intervention_probe_assignment.google_chart
  end
    

  def display_assessment_links(probe_assignment)
    s=''
    if !probe_assignment.probe_definition.probe_questions.blank?
      s= link_to("Administer Assessment", new_assessment_probes_path(@intervention,probe_assignment)) + '<br />' 
      if !probe_assignment.probes.blank? and !probe_assignment.probes.last.probe_questions.blank?
        s+=link_to( "Update Assessment", update_assessment_probes_path(@intervention,probe_assignment)) + '<br />'
      end
    end
    s
  end



end

 
