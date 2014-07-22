module ProbesHelper
  def probe_graph(intervention_probe_assignment, _count)
    graph = intervention_probe_assignment.graph(params[:graph]).to_html
  end

  def preview_graph_link(graph_type, intervention, probe_assignment, _probe_assignment_counter)
    link_to "Preview #{graph_type.humanize} Graph",
            preview_graph_url(intervention_id: intervention.id,
                              id: probe_assignment.id,
                              probe_definition_id: probe_assignment.probe_definition_id,
                              graph: graph_type.to_s),
            class: "preview_graph"
  end
end


