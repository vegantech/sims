class Gchart
  attr_accessor :chds
  def self.url
   '/chart?'
  end

  def text_encoding
     chds = @chds || dataset.map{|ds| "#{ds[:min_value]},#{ds[:max_value]}" }.join(",")
     if custom and custom.include?("&chds")
       "t" + number_visible + ":" + datasets.map{ |ds| ds.map{|e|e||'_'}.join(',') }.join('|') #+ "&chds=" + chds
     else
       "t" + number_visible + ":" + datasets.map{ |ds| ds.map{|e|e||'_'}.join(',') }.join('|') + "&chds=" + chds
     end
  end
end
