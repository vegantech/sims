module Sims
  class BestStandardsSupport
    def initialize(app, _type = true)
      @app = app
      @header= "IE=Edge,chrome=IE7"
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers["X-UA-Compatible"] = @header
      headers['P3P']= 'CP = "CAO PSA OUR"'
      [status, headers, body]
    end
  end
end
