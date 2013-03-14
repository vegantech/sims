module Sims
  class BestStandardsSupport
    def initialize(app, type = true)
      @app = app

      @header = case type
      when true
        "IE=Edge,chrome=IE7"
      when :builtin
        "IE=Edge"
      when false
        nil
      end
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers["X-UA-Compatible"] = @header
      headers['P5P']= 'CP = "CAO PSA OUR"'
      [status, headers, body]
    end
  end
end
