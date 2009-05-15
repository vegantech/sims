begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.metrics  = [:churn, :saikuro, :stats, :flog, :flay, :reek, :roodi]
  end

rescue LoadError
  puts 'install jscruggs-metric_fu if you would like to see more code metrics'
end
