class ProbeBar 
  attr_accessor :score, :date, :index, :graph
  CSS_CLASSES= %w[one two three four five six seven eight nine ten]

  OFFSET = 90
  INCREMENT = 70

  def initialize(opts={})
    @score=opts[:score].to_i
    @date=opts[:date]
    @index=opts[:index]
    @graph=opts[:graph]
    @css_class=CSS_CLASSES[@index].to_s.downcase
    @floor_cutoff = 24
 
  end

  def to_html
    scaled_value = scale_graph_value(@score, @graph.data_max, ProbeGraph::SCALE_MAX)


      bar_left = OFFSET + (INCREMENT * index)
      label_left = bar_left - 10
      
      neg_bottom = (ProbeGraph::SCALE_MIN + @graph.scaled_min) - scaled_value
      if scaled_value == 0
        zero = "white" 
      else
        zero = "#5A799D"
      end

      if @score >= 0
        zero = "#5A799D"
        negative = "hidden"
        positive = "visible"
      else
        zero = "#8DACD0"
        negative = "visible"
        positive = "hidden"
      end
     
      html = <<-"HTML"
      
      <dt class="#{@css_class}" style="left: #{label_left}px; bottom: 0px !important;">#{@date}<br />#{@score.to_s}</dt>
      <dd class="#{@css_class}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{positive}; left: #{bar_left}px; bottom: #{@graph.pos_bottom}px !important;" title="#{@score}">#{scaled_value < @floor_cutoff ? '' : @score}</dd>
      <dd class="bottom_#{@css_class}" style="height: #{scaled_value}px; background-color: #{zero}; visibility: #{negative}; left: #{bar_left}px;  bottom: #{neg_bottom}px !important; " title="#{@score}">#{scaled_value < @floor_cutoff ? '' : @score}</dd>
      
      HTML
    end
 

  def scale_graph_value(data_value, data_max, max)
    ((data_value.to_f.abs / data_max.to_f) * max).round
  end
end
