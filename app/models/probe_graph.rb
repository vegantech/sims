class ProbeGraph

  attr_accessor :benchmark, :minimum, :maximum,:bars


  CSS_CLASSES= %w[one two three four five six seven eight nine ten]
  def initialize(ipa, graph_index=0)
    @bars=[]
    @benchmarks=[]
    setup_graph(ipa)
  end

  def display_graph(index=0)
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
    @benchmark={:score => 'N/A', :grade_level => 'N/A'}
  end

  def setup_max_min_and_title(ipa)
    @minimum= ipa.probe_definition.minimum_score
    @maximum= ipa.probe_definition.maximum_score
    @title = ipa.probe_definition.title
  end

  def setup_bars(ipa)
    probes_collection = ipa.probes.for_graph.reverse
    probes_collection.each_with_index do |probe,index|
      @bars << ProbeBar.new(:css_class=>CSS_CLASSES[index],
                           :date=> probe.administered_at.to_s(:report),
                           :score => probe.score)
    end
  end

   
  def setup_width_and_height
    @width= @bars.size * 70
    @line_width = @width + 48
    @height = 165
    @floor_cutoff = 24
  end

  def setup_data_min_and_data_max
    #defaults
    puts @bars.inspect
    @data_min = (@minimum || @bars.collect{|bar| bar.score}.compact.min).to_i
    if @maximum
      @data_max = @maximum- @data_min
    else
      @data_max = (@bars.collect{|bar| bar.score}.compact.max || 10).to_i 
    end

  end
  
 def sims_bar_graph(count)
   setup_width_and_height
   setup_data_min_and_data_max
   data_benchmark = benchmark[:score]

   data_min=@data_min
   data_max=@data_max

   
    html = <<-"HTML"
    <style>
    #vertgraph_#{count} {
          width: #{@width}px; 
          height: #{@height}px; 
      }
    HTML

    bar_offset = 90
    bar_increment = 70
    scaled_min = scale_graph_value(data_min, data_max, 80)
    
    scaled_benchmark = scale_graph_value(data_benchmark, data_max, 80)
    pos_bottom = 40 + scaled_min
    if data_benchmark != 'N/A' && data_benchmark >= 0
      pos_benchmark = 40 + scaled_min + scaled_benchmark
    else
      pos_benchmark = 40 + scaled_min - scaled_benchmark
    end
    
    pos_max = 40 + scaled_min + scale_graph_value(data_max,data_max,80)
    
    @bars.each_with_index do |bar, index|
      scaled_value = scale_graph_value(bar.score, data_max, 80)
      bar_left = bar_offset + (bar_increment * index)
      label_left = bar_left - 10
      neg_bottom = (40 + scaled_min) - scaled_value
      
      html += <<-HTML
      #vertgraph_#{count} dl dd.#{bar.css_class} { left: #{bar_left}px; background-color: #5A799D;  bottom: #{pos_bottom}px !important; }
      #vertgraph_#{count} dl dd.bottom_#{bar.css_class} { left: #{bar_left}px; background-color: #8DACD0; bottom: #{neg_bottom}px !important; }
      #vertgraph_#{count} dl dt.#{bar.css_class} { left: #{label_left}px; bottom: 0px !important; }
        
      HTML
    end
    
    html += <<-"HTML"
      </style>
      
      <div style="border: thin solid #5A799D;margin-left: 10px; margin-bottom: 5px;">
        <p style="text-align:center;">
        
          Current scores for "#{@title}"<br />
          Benchmark: #{@benchmark[:score]} at grade level #{@benchmark[:grade_level]}
        </p>
      <div id="vertgraph_#{count}" class="vertgraph">
      
        <dl>
    HTML
    
    @bars.each_with_index do |bar, index|
      scaled_value = scale_graph_value(bar.score, data_max, 80)
      zero = "white" if scaled_value == 0
      if bar.score >= 0
        negative = "hidden"
        positive = "visible"
      else
        negative = "visible"
        positive = "hidden"
      end
     
      
      html += <<-"HTML"
      
      <dt class="#{bar.css_class}">#{bar.date}<br />#{bar.score.to_s}</dt>
      <dd class="#{bar.css_class}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{positive};" title="#{bar.score}">#{scaled_value < @floor_cutoff ? '' : bar.score}</dd>
      <dd class="bottom_#{bar.css_class}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{negative}" title="#{bar.score}">#{scaled_value < @floor_cutoff ? '' : bar.score}</dd>
      
      HTML
    end
        
    html += <<-"HTML"
        </dl>
        
      
        <div id="zero_line" style="position:absolute; bottom: #{pos_bottom}px !important; height: 15px; width: #{@line_width}px; border-bottom: 1px solid black;">&nbsp;0
      </div>
      
    HTML
    if data_benchmark != 'N/A'
    
    html += <<-"HTML" 
    <div id="benchmark_line" style="position: absolute; bottom: #{pos_benchmark}px !important; height: 15px; width: #{@line_width}px; border-bottom: 1px solid orange;">&nbsp;Benchmark
      </div>
      
    HTML
    
    end

    
    html += <<-"HTML"

<div id="max_line" style="position: absolute; bottom: #{pos_max}px !important; height: 15px; width: #{@line_width}px; border-bottom: 1px dotted #888888;">&nbsp;#{data_max}
      </div>
      
    
    
    </div>
    </div>
    HTML
    
    html
  end
  
  def scale_graph_value(data_value, data_max, max)
    ((data_value.to_f.abs / data_max.to_f) * max).round
  end
 


 
end
