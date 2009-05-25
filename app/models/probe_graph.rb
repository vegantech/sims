class ProbeGraph

  attr_accessor :benchmarks, :minimum, :maximum,:bars, :data_max,:scaled_min, :pos_bottom, :line_width


  GRAPH_HEIGHT = 165
  SCALE_MAX = 80
  SCALE_MIN = 40


  def initialize(ipa, graph_index=0)
    @bars=[]
    @benchmarks=[]
    @ipa=ipa
  end

  def display_graph(index=0)
    setup_graph(@ipa)
    sims_bar_graph(index)
  end


private
  def setup_graph(ipa)
    setup_benchmark(ipa)
    setup_bars(ipa)
    setup_max_min_and_title(ipa)
  end

  def setup_benchmark(ipa)
    #student_grade = intervention_probe_assignment.student_grade
    #     ProbeDefinitionBenchmark.find_benchmark_data(student_grade, 
 #     intervention_probe_assignment.probe_definition)
    @benchmarks=ipa.probe_definition.probe_definition_benchmarks
    if @benchmarks.present?
      @benchmarks = @benchmarks.collect{|b| {:score=>b.benchmark, :grade_level => b.grade_level}}
    else
      @benchmarks=[{:score => 'N/A', :grade_level => 'N/A'}]
    end
  end

  def setup_max_min_and_title(ipa)
    @minimum= ipa.probe_definition.minimum_score
    @maximum= ipa.probe_definition.maximum_score
    @title = ipa.probe_definition.title
  end

  def setup_bars(ipa)
     probes_collection = ipa.probes.reject{|e| e.administered_at.blank? || e.score.blank?}.sort_by(&:administered_at)[0..8].reverse #.for_graph.reverse
    
    
    probes_collection.each_with_index do |probe, index|
      @bars << ProbeBar.new(:index=>index,
                           :date=> probe.administered_at.to_s(:report),
                           :score => probe.score, :graph =>self)
    end
  end

   
  def setup_width_and_height
    @width= @bars.size * ProbeBar::INCREMENT
    @line_width = @width + 48
  end

  def get_minimum_or_zero_from_bars
    ([0] | @bars.collect{|bar| bar.score}).compact.min
  end



  def setup_data_min_and_data_max
    #defaults
    @data_min = (@minimum || get_minimum_or_zero_from_bars).to_i
    if @maximum
      @data_max = @maximum- @data_min
    else
      @data_max = (@bars.collect{|bar| bar.score}.compact.max || 10).to_i 
    end

    @data_max = 10 if @data_max == @data_min && @data_min == 0


   @scaled_min = scale_graph_value(@data_min, @data_max, SCALE_MAX)
   @pos_bottom = SCALE_MIN  + @scaled_min
   @pos_max = @pos_bottom  + scale_graph_value(@data_max,@data_max,SCALE_MAX)

  end
  
 def sims_bar_graph(count)
   setup_width_and_height
   setup_data_min_and_data_max

    
    
    html = <<-"HTML"
      <div style="border: thin solid #5A799D;margin-left: 10px; margin-bottom: 5px;">
        <p style="text-align:center;">
        
          Current scores for "#{@title}"<br />
    HTML

    @benchmarks.each do |benchmark|
    html += <<-"HTML"

          Benchmark: #{benchmark[:score]} at grade level #{benchmark[:grade_level]} <br />

    HTML
    end

    html += <<-"HTML"
        </p>
      <div id="vertgraph_#{count}" class="vertgraph" style="width: #{@width}px; height: #{GRAPH_HEIGHT}px;">
      
        <dl>
    HTML

    html += @bars.collect(&:to_html).join("\n")

=begin    
    
    @bars.each_with_index do |bar, index|
      scaled_value = scale_graph_value(bar.score, data_max, SCALE_MAX)


      bar_left = BAR_OFFSET + (BAR_INCREMENT * index)
      label_left = bar_left - 10
      neg_bottom = (SCALE_MIN + @scaled_min) - scaled_value
      if scaled_value == 0
        zero = "white" 
      else
        zero = "#5A799D"
      end

      if bar.score >= 0
        zero = "#5A799D"
        negative = "hidden"
        positive = "visible"
      else
        zero = "#8DACD0"
        negative = "visible"
        positive = "hidden"
      end
     
      html += <<-"HTML"
      
      <dt class="#{bar.css_class}" style="left: #{label_left}px; bottom: 0px !important;">#{bar.date}<br />#{bar.score.to_s}</dt>
      <dd class="#{bar.css_class}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{positive}; left: #{bar_left}px; bottom: #{pos_bottom}px !important;" title="#{bar.score}">#{scaled_value < @floor_cutoff ? '' : bar.score}</dd>
      <dd class="bottom_#{bar.css_class}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{negative}; left: #{bar_left}px;  bottom: #{neg_bottom}px !important; " title="#{bar.score}">#{scaled_value < @floor_cutoff ? '' : bar.score}</dd>
      
      HTML
    end
=end        
    html += <<-"HTML"
        </dl>
        
      
        <div id="zero_line" style="position:absolute; bottom: #{@pos_bottom}px !important; height: 15px; width: #{@line_width}px; border-bottom: 1px solid black;">&nbsp;0
      </div>
      
    HTML

    html += benchmark_line
    
    html += <<-"HTML"

<div id="max_line" style="position: absolute; bottom: #{@pos_max}px !important; height: 15px; width: #{@line_width}px; border-bottom: 1px dotted #888888;">&nbsp;#{@data_max}
      </div>
      
    
    
    </div>
    </div>
    HTML
    
    html
  end
  
  def scale_graph_value(data_value, data_max, max)
    ((data_value.to_f.abs / data_max.to_f) * max).round
  end



  def benchmark_line

    e=@benchmarks.collect do |benchmark|
      if benchmark[:score] == 'N/A'
        ''
      else
        score=benchmark[:score].to_i
        sign=score/score.abs
        scaled_benchmark = sign*scale_graph_value(benchmark[:score].to_i,@data_max,SCALE_MAX) + @pos_bottom
       "<div style=\"position: absolute; bottom: #{scaled_benchmark}px !important; height: 15px; width: #{@line_width}px; border-bottom: 1px solid orange;\">&nbsp;#{score}</div>"
      end 
    end
    e.join(" ")
  end



 
end
