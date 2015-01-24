class Gchart
  attr_accessor :chds
  def self.url
    '/chart?'
  end


  def text_encoding
    chds = @chds || dataset.map{|ds| "#{ds[:min_value]},#{ds[:max_value]}" }.join(",")
    if custom and custom.include?("&chds")
      text_encoding_without_chds
    else
      text_encoding_without_chds + "&chds=" + chds
    end
  end

  private
  def text_encoding_without_chds
    "t" + number_visible + ":" + datasets.map{ |ds| ds.map{|e|e||'_'}.join(',') }.join('|')
  end

end
