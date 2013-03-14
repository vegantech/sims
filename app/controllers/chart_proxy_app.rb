class ChartProxyApp < ActionController::Metal
  def index
    self.response_body = Net::HTTP.get("chart.apis.google.com", "/chart?#{env["QUERY_STRING"]}")
    self.content_type = 'image/png'
    self.headers['Content-Disposition'] = "inline"
  end
end
