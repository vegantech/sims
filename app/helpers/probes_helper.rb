module ProbesHelper
  def probe_graph(intervention_probe_assignment, count)
    graph = intervention_probe_assignment.graph(params[:graph])

    html = <<-"HTML"
        <p style="text-align:center;">
          Current scores for "#{graph.title}"<br />
    HTML

    graph.benchmarks.each do |benchmark|
    html += <<-"HTML"

          Benchmark: #{benchmark[:benchmark]} at grade level #{benchmark[:grade_level]} <br />

    HTML
    end
    html += "Goal: #{graph.goal} <br />"  if graph.goal

   ( html + "</p>" +
      graph.graph).html_safe
  end

  def preview_graph_link(graph_type, intervention, probe_assignment, probe_assignment_counter)
    link_to "Preview #{graph_type.humanize} Graph", preview_graph_url(:intervention_id => intervention.id,
                                                                      :id => probe_assignment.id,
                                                                      :probe_definition_id => probe_assignment.probe_definition_id,
                                                                      :graph=>graph_type.to_s), :class => "preview_graph"
  end
end


