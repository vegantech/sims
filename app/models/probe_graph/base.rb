class ProbeGraph::Base
  require 'probe_graph/html'
  include ProbeGraph::HTML
  attr_reader :benchmarks, :title, :goal

  def self.build(opts = {})
    case opts[:graph_type].to_s
    when  "bar"
      ProbeGraph::Bar.new(opts)
    when 'scaled_line'
      ProbeGraph::Linexy.new(opts)
    else
      ProbeGraph::Line.new(opts)
    end
  end

  def initialize(opts ={})
    @probe_definition = opts[:probe_definition]
    @title = @probe_definition.title
    @benchmarks = opts[:probe_definition].probe_definition_benchmarks
    @goal = opts[:goal]
    @graph_type = opts[:graph_type].to_s
    @probes = opts[:probes].to_a
    @district = opts[:district]
    @first_date = opts[:first_date]
    @end_date = opts[:end_date]
    @chxp = []
  end

  def graph
    return 'no scores' if probes_for_graph.empty?
    build_graph
    #put common stuff here
  end

  protected

  def chxp
    "chxp=#{@chxp.join('|')}"
  end

  def probes_for_graph
    @pfg ||= @probes.reject{|e| e.administered_at.blank? || e.score.blank?}.sort_by(&:administered_at)
  end

  def benchmarks_with_goal
    (@benchmarks |[goal_benchmark]).compact
  end

  def goal_benchmark
    ProbeDefinitionBenchmark.new(:benchmark=>@goal, :grade_level => '   Goal') if @goal.present?
  end


  def custom_string(custom_chm)
    [custom_chm,chxp].compact.join("&")
  end

  def gchart(probes_for_this_graph, chm)
    Gchart.send self.class::CHART,{
      :data => probes_for_this_graph.collect(&:score), :axis_with_labels => 'x,x,y,r',
      :axis_labels => axis_labels(probes_for_this_graph),
      :bar_width_and_spacing => '30,25',
      :bar_colors => probes_for_this_graph.collect{|e| (e.score<0)? '8DACD0': '5A799D'}.join("|"),
      :format=>'image_tag',
      :min_value=>min, :max_value=>max,
      :encoding => 'text',
      :custom => custom_string(chm),
      :size => '600x250'}
  end

  def y_axis_labels
    if max == min
      vals = [max]
    else
      diff = max-min
      step = (diff/10.0).ceil
      vals = ((min..max).step(step).to_a | [min,0,max]).sort.uniq
    end
    unless @y_in_chxp
      to_chxp = "2,#{vals.collect{|v| scale_value(v)*100}.join(",")}"
      @chxp << to_chxp
      @y_in_chxp = true
    end
    vals
  end


  def axis_labels(p_for_this_graph)
    [
      p_for_this_graph.collect{|p| p.administered_at.to_s(:report)},
      p_for_this_graph.collect(&:score),
      y_axis_labels,
      r_axis_labels
    ]
  end

  def r_axis_labels
    benchmarks_with_goal.collect{|b| "#{b.benchmark}-  #{b.grade_level}"}
  end
  def dots_for_line_graph
    'o,000000,0,,3.0'
  end

  def numbers_on_line
    #show the value in black on the graph
    'chm=N,000000,0,,12,,t'
  end

  def max_min_zero
    #min, zero, max
    "r,000000,0,0.0,0.002|r,000000,0,#{scale_value(0) - 0.001},#{scale_value(0) + 0.001}|r,000000,0,0.998,1.0"
  end

  def benchmark_lines
    if benchmarks_with_goal.present?
      @chxp <<  "3,#{benchmarks_with_goal.collect{|b| scale_value(b.benchmark)*100}.join(",")}"
      "#{benchmarks_with_goal.collect{|b| "r,#{b.color},0,#{scale_value(b.benchmark) -0.003},#{scale_value(b.benchmark) +0.003}"}.join("|")}"
    end
  end

  def scale_value(value)
    (value-min).to_f/(max-min).to_f
  end

  def scores
    probes_for_graph.collect(&:score)
  end

  def scores_with_goal
    s=scores
    s << @goal.to_i if @goal
    s
  end

  def min
    @min ||= @probe_definition.minimum_score || (scores_with_goal.min >=0 ? 0 : scores_with_goal.min)
  end

  def max
    @max ||= @probe_definition.maximum_score || (scores_with_goal.max <= 10 ? 10 : scores_with_goal.max)
  end

  def chds
    #min am nax for data series
    a=[0,line_graph_date_denom,min,max]
    a *= 2 if @goal #aim line and data have same range
    a.join(",")
  end

  def scaled_dates pp
    pp.collect{|e| (e.administered_at - line_graph_left_date).to_i}
  end
end
