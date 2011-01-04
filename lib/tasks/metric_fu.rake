begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    #define which metrics you want to use
    config.metrics  = [:churn, :saikuro, :stats,  :flay, :reek, :roodi, :rails_best_pracices] #flog
    config.graphs   =[:stats,  :flay, :reek, :roodi, :rails_best_pracices ] #flog
    # ...
  end

rescue LoadError
end
