module ProbeGraph::HTML
  include ActionView::Helpers::TagHelper
  def to_html
    html_header + graph.html_safe
  end

  protected
  def html_header
    content_tag :p,
                [html_title,html_benchmarks, html_goal].flatten.compact.join("<br />").html_safe,
                :style =>"text-align:center"
  end

  def html_benchmarks
    benchmarks.collect{|benchmark|
      "Benchmark: #{benchmark[:benchmark]} at grade level #{benchmark[:grade_level]}"}
  end

  def html_goal
    "Goal: #{goal}"  if goal
  end

  def html_title
    %Q{Current scores for "#{title}"}
  end
end
