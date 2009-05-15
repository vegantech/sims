class ProbeBar 
  attr_accessor :score, :date, :css_class


  def initialize(opts={})
    @score=opts[:score]
    @date=opts[:date]
    @css_class=opts[:css_class].to_s.downcase
  end


end
