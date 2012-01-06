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
    @first_date = opts[:first_date]
    @end_date = opts[:end_date]
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
    singleton_class.send :include, ProbeGraph::WithAimLine
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
    @benchmarks |[goal_benchmark]
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
    s << @goal.to_i if @goal
    s
    
  end

  def min
     @probe_definition.minimum_score || (scores_with_goal.min >=0 ? 0 : scores_with_goal.min)
  end

  def max
     @probe_definition.maximum_score || (scores_with_goal.max <= 10 ? 10 : scores_with_goal.max)
  end

  module WithAimLine
    def google_line_chart
      #groups of 10, repeats the previous point on the next graph as a line graph needs at least 2 points
      return ''if probes_for_graph.empty?
      @chxp=[]
      group=0
      probes_for_graph.in_groups_of(10000,false).collect{ |probes_for_this_graph|
        custom_chm=[numbers_on_line,max_min_zero,dots_for_line_graph,benchmark_lines].compact.join("|")
        if group>0
          probes_for_this_graph= [probes_for_graph[group*10-1]] + probes_for_this_graph
        end
        group+=1
        if probes_for_this_graph.size == 1
          probes_for_this_graph[1] = probes_for_this_graph[0]
          #        custom_chm << "|@o,000000,0,0:#{scale_value(probes_for_this_graph[0].score)},4"
        end

        custom_string = [custom_chm,chart_margins,chxp,chls,line_chds].compact.join("&")

        Gchart.line_xy({:data => line_graph_data(probes_for_this_graph),
                       :axis_with_labels => 'x,x,y,r',
                       :axis_labels => line_axis_labels,
                       :bar_colors => "8DACD0,99DD99",
                       :format=>'image_tag',
                       :encoding => 'text',
                       :custom => custom_string,
                       :bar_width_and_spacing => nil,
                       :size => '600x250',
                       :chds => nil,
                       :axis_range => [[0,line_graph_date_denom],[],[0,100],[0,100]]
        })}.join("<br />")



    end

    def chls
      "chls=2|1,4,2"
    end

    def line_chds
      "chds=#{chds}"
    end

    def chds
      a=[0,line_graph_date_denom,min,max].join(",")
      if @goal
        [a,a].join(",")
      else
        a
      end
    end

    protected

    def line_axis_labels
      [
        [line_graph_left_date, line_graph_left_date + line_graph_date_denom/4 , line_graph_left_date + line_graph_date_denom/2, line_graph_left_date + 0.75 * line_graph_date_denom, line_graph_right_date].uniq,
        [],
        [min,0,max],
        benchmarks_with_goal.collect{|b| "#{b.benchmark}-  #{b.grade_level}"},
      ]


    end

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

    #TODO
    def line_graph_left_date
      (probes_for_graph.collect(&:administered_at) |[@first_date]).min
    end

    def line_graph_right_date
      (probes_for_graph.collect(&:administered_at) |[@end_date]).max
    end

    def line_graph_date_denom
      scale_denom=line_graph_right_date - line_graph_left_date
      scale_denom = 0.0001 if scale_denom.zero?
      scale_denom
    end
    def scaled_dates pp
      pp.collect{|e| (e.administered_at - line_graph_left_date).to_i}
    end
  end
end
