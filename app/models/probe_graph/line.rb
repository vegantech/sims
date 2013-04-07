class ProbeGraph::Line < ProbeGraph::Base
  CHART="line"
  def build_graph
    #groups of 10, repeats the previous point on the next graph as a line graph needs at least 2 points
    group=0
    probes_for_graph.in_groups_of(10,false).collect{ |probes_for_this_graph|
      custom_chm=[numbers_on_line,max_min_zero,dots_for_line_graph,benchmark_lines].compact.join("|")
      if group>0
        probes_for_this_graph= [probes_for_graph[group*10-1]] + probes_for_this_graph
      end
      group+=1
      if probes_for_this_graph.size == 1
        custom_chm << "@o,000000,0,0:#{scale_value(probes_for_this_graph[0].score)},4"
      else
      end

      gchart(probes_for_this_graph, custom_chm)
    }.join("<br />")
  end

end
