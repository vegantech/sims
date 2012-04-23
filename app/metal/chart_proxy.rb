class ChartProxy
  require 'net/http'
  require 'uri'

  def initialize(app)
    @app = app
  end

  def each(&block)
    @response.each(&block)
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    if env["PATH_INFO"] =~ /^\/chart/
      k= Net::HTTP.get("chart.apis.google.com", "/chart?#{env["QUERY_STRING"]}")
      [200, {"Content-Type" => "image/png","Content-Disposition" => "inline" }, [k]]
    else
      @app.call(env)
    end
  end
end
