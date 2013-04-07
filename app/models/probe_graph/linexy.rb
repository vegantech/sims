class ProbeGraph::Linexy < ProbeGraph::Base
  def build_graph
    if probes_for_graph.count >= 50
      custom_chm="chm=" + [max_min_zero,dots_for_line_graph,benchmark_lines].compact.join("|")
    else
      custom_chm=[numbers_on_line,max_min_zero,dots_for_line_graph,benchmark_lines].compact.join("|")
    end

    Gchart.line_xy({:data => line_graph_data(probes_for_graph),
                   :axis_with_labels => 'x,x,y,r',
                   :axis_labels => line_axis_labels,
                   :bar_colors => "8DACD0,99DD99",
                   :format=>'image_tag',
                   :encoding => 'text',
                   :custom => custom_string(custom_chm),
                   :bar_width_and_spacing => nil,
                   :size => '800x250',
                   :thickness => "2|1,4,2", #thickness of scores | aim line with dashing
                   :chds => chds,
                   :axis_range => [[0,line_graph_date_denom],[],[0,100],[0,100]]
    })
  end
  protected

  def line_graph_data(probes_for_this_graph)
    a=[]
    lg_dates=scaled_dates(probes_for_this_graph)
    a << lg_dates
    a << probes_for_this_graph.collect(&:score)
    if @goal
      a << [lg_dates.first, (@end_date - line_graph_left_date).to_i]
      a << [probes_for_this_graph.first.score, @goal]
    end
    a
  end

  def admin_at_dates
    @admin_at_dates ||= (probes_for_graph.collect(&:administered_at) |[@first_date,@end_date])
  end

  #TODO
  def line_graph_left_date
    admin_at_dates.min
  end

  def line_graph_right_date
    admin_at_dates.max
  end

  def line_graph_date_denom
    scale_denom=line_graph_right_date - line_graph_left_date
    scale_denom = 0.0001 if scale_denom.zero?
    scale_denom.to_i
  end

  def line_axis_labels
    [
      [line_graph_left_date, line_graph_left_date + line_graph_date_denom/4 , line_graph_left_date + line_graph_date_denom/2, line_graph_left_date + 0.75 * line_graph_date_denom, line_graph_right_date].uniq,
      [],
      y_axis_labels,
      r_axis_labels
    ]
  end

end
