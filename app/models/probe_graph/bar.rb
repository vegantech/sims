class ProbeGraph::Bar < ProbeGraph::Base
  CHART="bar"
  def build_graph
    #groups of 10
    custom_chm=[numbers_in_bars,max_min_zero,benchmark_lines].compact.join("|")
    probes_for_graph.in_groups_of(10,false).collect{|probes_for_this_graph|
      gchart(probes_for_this_graph, custom_chm)
      }.join("<br />")
  end

  protected
  def numbers_in_bars
    #show the value in white in the bar
    'chm=N,FFFFFF,0,,12,,c'
  end

end
