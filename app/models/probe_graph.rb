class ProbeGraph
  attr_reader :benchmarks, :title, :goal

  def initialize(opts ={})
    @probe_definition = opts[:probe_definition]
    @title = @probe_definition.title
    @benchmarks = opts[:probe_definition].probe_definition_benchmarks
    @goal = opts[:goal]
    @graph_type = opts[:graph_type].to_s
    @probes = opts[:probes].to_a
    @district = opts[:district]
  end


  def graph
    if @graph_type=="bar"
      bar_chart
    else
      line_chart# or "graph_type"=="line"
    end
  end

  def bar_chart
    google_bar_chart
  end

  def line_chart
    old_line_chart
  end

  def old_line_chart
    #remove this when the mmsd chart is incorporated
    google_line_chart
  end

  def new_line_chart
    #mmsd only initially
  end

  def google_line_chart
    #groups of 10, repeats the previous point on the next graph as a line graph needs at least 2 points
   return ''if probes_for_graph.empty?
    @chxp=[]
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

      custom_string = [custom_chm,chart_margins,chxp].compact.join("&")
    
      Gchart.line({:data => probes_for_this_graph.collect(&:score), :axis_with_labels => 'x,x,y,r',
                 :axis_labels => axis_labels(probes_for_this_graph), 
                 :bar_width_and_spacing => '30,25',
                 :bar_colors => probes_for_this_graph.collect{|e| (e.score<0)? '8DACD0': '5A799D'}.join("|"),
                 :format=>'image_tag',
                 :min_value=>min, :max_value=>max,
                 :encoding => 'text',
                 :custom => custom_string,
                 :size => '600x250'

                 })}.join("<br />")



 end

 def chxp
   "chxp=#{@chxp.join('|')}"
 end

 def google_bar_chart
   #groups of 10
   return ''if probes_for_graph.empty?
    @chxp=[]
    custom_chm=[numbers_in_bars,max_min_zero,benchmark_lines].compact.join("|")
    custom_string = [custom_chm,chart_margins,chxp].compact.join("&")
    probes_for_graph.in_groups_of(10,false).collect{|probes_for_this_graph|
      Gchart.bar(:data => probes_for_this_graph.collect(&:score), :axis_with_labels => 'x,x,y,r',
                 :axis_labels => axis_labels(probes_for_this_graph),
                 :bar_width_and_spacing => '30,25',
                 :bar_colors => probes_for_this_graph.collect{|e| (e.score<0)? '8DACD0': '5A799D'}.join("|"),
                 :format=>'image_tag',
                 :min_value=>min, :max_value=>max,
                 :encoding => 'text',
                 :custom => custom_string,
                 :size => '600x250'

                )}.join("<br />")
  end

  def probes_for_graph
    @probes.reject{|e| e.administered_at.blank? || e.score.blank?}.sort_by(&:administered_at)
  end

  def benchmarks_with_goal
    @benchmarks |goal_benchmark.to_a
  end

  def goal_benchmark
      ProbeDefinitionBenchmark.new(:benchmark=>@goal, :grade_level => '   Goal') if @goal
  end

  protected

  def axis_labels(p_for_this_graph)
      [
        p_for_this_graph.collect{|p| p.administered_at.to_s(:report)}, 
        p_for_this_graph.collect(&:score), 
        [min,0,max],
        benchmarks_with_goal.collect{|b| "#{b.benchmark}-  #{b.grade_level}"},
      ] 
  end

  def dots_for_line_graph
      'o,000000,0,,3.0'
  end

  def numbers_on_line
    #show the value in black on the graph
      'chm=N,000000,0,,12,,t'
  end
  def numbers_in_bars
    #show the value in white in the bar
      'chm=N,FFFFFF,0,,12,,c'
  end

  def max_min_zero
    #min, zero, max
    @chxp<<"2,#{scale_value(min)*100},#{scale_value(0)*100},#{scale_value(max)*100}"
    "r,000000,0,0.0,0.002|r,000000,0,#{scale_value(0) - 0.001},#{scale_value(0) + 0.001}|r,000000,0,0.998,1.0"
  end

  def benchmark_lines
    if benchmarks_with_goal.present?
      @chxp <<  "3,#{benchmarks_with_goal.collect{|b| scale_value(b.benchmark)*100}.join(",")}"
      "#{benchmarks_with_goal.collect{|b| "r,#{b.color},0,#{scale_value(b.benchmark) -0.003},#{scale_value(b.benchmark) +0.003}"}.join("|")}"
    end
  end

  def chart_margins
    "chma=20,20,20,20"
    ""
  end

  
  def scale_value(value)
    (value-min).to_f/(max-min).to_f
  end

  def scores
    probes_for_graph.collect(&:score)
  end

  def scores_with_goal
    s=scores
    s << goal.to_i if goal?
    s
    
  end

  def min
     @probe_definition.minimum_score || (scores_with_goal.min >=0 ? 0 : scores_with_goal.min)
  end

  def max
     @probe_definition.maximum_score || (scores_with_goal.max <= 10 ? 10 : scores_with_goal.max)
  end

end
