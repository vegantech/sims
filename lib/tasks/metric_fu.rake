begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    #define which metrics you want to use
    config.metrics  = [:churn, :saikuro, :stats,  :flay, :reek, :roodi, :rails_best_practices] #flog
    config.graphs   =[:stats,  :flay, :reek, :roodi, :rails_best_practices ] #flog
    # ...
  end

rescue LoadError
end
