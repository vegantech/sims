module ProbesHelper
  
 def probe_graph(intervention_probe_assignment,count)

    benchmark_data=Array.new
    grades_as_ints = Array.new
    data = Array.new
    
    student_grade = intervention_probe_assignment.student_grade
    probe_definition = intervention_probe_assignment.probe_definition
    
    benchmark_data = [nil,nil]
 
    #     ProbeDefinitionBenchmark.find_benchmark_data(student_grade, 
 #     intervention_probe_assignment.probe_definition)
    benchmark_grade_level = benchmark_data[0]
    benchmark_score = benchmark_data[1]
    
    probesCollection = intervention_probe_assignment.probes.for_graph
    
    probesCollection=probesCollection.reverse
    probesCollection.each_with_index do |probe,index|
      classes= %w[one two three four five six seven eight nine ten]
      date = probe.administered_at.strftime("%m/%d/%y")
      data << [classes[index], date, 
        probe_definition.title, 
        benchmark_grade_level, benchmark_score, 
        probe_definition.maximum_score, 
        probe_definition.minimum_score, 
        probe.score ]
  
    end
  sims_bar_graph(count,data)
end

  
 def sims_bar_graph(count, data=[[]])
    
    width = data.size * 70
    line_width = width + 48
    height = 165
    floor_cutoff = 24 
    if data[0][5] != nil && data[0][6] != nil
      #if maximum and minimum scores
      data_max = data[0][5] - data[0][6]
      data_min = data[0][6]
    else
      #if no maximum or minimum scores
      if data[0][7] == 0
        data_max = 10
        data_min = 0
      else  
        data_max = data.inject(0) { |memo, array| array.last > memo ? array.last : memo }
      end
    end
    
    data_benchmark = data[0][3]
    
    if data[0][3] == nil || data[0][3] == "" 
      data[0][3] = "N/A"
    end
    if data[0][4] == nil || data[0][4] == ""
      data[0][4] = "N/A"
    end
    
    html = <<-"HTML"
    <style>
    #vertgraph_#{count} {
          width: #{width}px; 
          height: #{height}px; 
          position: relative; 
          left: 10px;  
          font-family: "Lucida Grande", Verdana, Arial;
      }
    
      #vertgraph_#{count} dl dd {
        position: absolute;
        width: 28px;
        height: 100px;
        bottom: 45px;
        padding: 0 !important;
        margin: 0 !important;
        text-align: center;
        font-weight: bold;
        color: white;
        line-height: 1.5em;
        overflow: hidden;
      }
      
      #vertgraph_#{count} dl dt {
        position: absolute;
        width: 60px;
        height: 34px;
        bottom: 0px;
        padding: 0 !important;
        margin: 0 !important;
        text-align: center;
        color: #444444;
        font-size: 0.8em;
      }
    HTML

    bar_offset = 90
    bar_increment = 70
    scaled_min = scale_graph_value(data_min, data_max, 80)
    
    scaled_benchmark = scale_graph_value(data_benchmark, data_max, 80)
    pos_bottom = 40 + scaled_min
    if data_benchmark != nil && data_benchmark >= 0
      pos_benchmark = 40 + scaled_min + scaled_benchmark
    else
      pos_benchmark = 40 + scaled_min - scaled_benchmark
    end
    
    data.each_with_index do |d, index|
      scaled_value = scale_graph_value(d.last, data_max, 80)
      bar_left = bar_offset + (bar_increment * index)
      label_left = bar_left - 10
      neg_bottom = (40 + scaled_min) - scaled_value
      
      html += <<-HTML
      #vertgraph_#{count} dl dd.#{d[0].to_s.downcase} { left: #{bar_left}px; background-color: #5A799D;  bottom: #{pos_bottom}px !important; }
      #vertgraph_#{count} dl dd.bottom_#{d[0].to_s.downcase} { left: #{bar_left}px; background-color: #8DACD0; bottom: #{neg_bottom}px !important; }
      #vertgraph_#{count} dl dt.#{d[0].to_s.downcase} { left: #{label_left}px; bottom: 0px !important; }
        
      HTML
    end
    
    html += <<-"HTML"
      </style>
      
      <div style="border: thin solid #5A799D;margin-left: 10px; margin-bottom: 5px;">
        <p style="text-align:center;">
        
          Current scores for "#{data[0][2]}"<br />
          Benchmark: #{data[0][3]} at grade level #{data[0][4]}
        </p>
      <div id="vertgraph_#{count}">
      
        <dl>
    HTML
    
    data.each_with_index do |d, index|
      scaled_value = scale_graph_value(d.last, data_max, 80)
      zero = "white" if scaled_value == 0
      if d.last >= 0
        negative = "hidden"
        positive = "visible"
      else
        negative = "visible"
        positive = "hidden"
      end
     
      
      html += <<-"HTML"
      
      <dt class="#{d.first.to_s.downcase}">#{d[1].to_s.humanize}<br />Score: #{d.last.to_s}</dt>
      <dd class="#{d.first.to_s.downcase}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{positive};" title="#{d.last}">#{scaled_value < floor_cutoff ? '' : d.last}</dd>
      <dd class="bottom_#{d.first.to_s.downcase}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{negative}" title="#{d.last}">#{scaled_value < floor_cutoff ? '' : d.last}</dd>
      
      HTML
    end
        
    html += <<-"HTML"
        </dl>
        
      
        <div id="zero_line" style="position:absolute; bottom: #{pos_bottom}px !important; height: 15px; width: #{line_width}px; border-bottom: 1px solid black;">&nbsp;0
      </div>
      
    HTML
    if data_benchmark 
    
    html += <<-"HTML" 
    <div id="benchmark_line" style="position: absolute; bottom: #{pos_benchmark}px !important; height: 15px; width: #{line_width}px; border-bottom: 1px solid orange;">&nbsp;Benchmark
      </div>
      
    HTML
    
    end
    html += <<-"HTML"
    
    </div>
    </div>
    HTML
    
    html
  end
  
  def scale_graph_value(data_value, data_max, max)
    ((data_value.to_f.abs / data_max.to_f) * max).round
  end
 
  def display_assessment_links(probe_assignment)
    s=''
    if !probe_assignment.probe_definition.probe_questions.blank?
      s= link_to("Administer Assessment", new_assessment_probes_path(@intervention,probe_assignment)) + '<br />' 
      if !probe_assignment.probes.blank? and !probe_assignment.probes.last.probe_questions.blank?
        s+=link_to( "Update Assessment", update_assessment_probes_path(@intervention,probe_assignment)) + '<br />'
      end
    end
    s
  end



end

 
