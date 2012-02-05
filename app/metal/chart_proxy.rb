# Allow the metal piece to run in isolation
#require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class ChartProxy
  require 'net/http'
  require 'uri'
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/chart/
      k= Net::HTTP.get("chart.apis.google.com", "/chart?#{env["QUERY_STRING"]}")
      [200, {"Content-Type" => "image/png","Content-Disposition" => "inline" }, [k]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
