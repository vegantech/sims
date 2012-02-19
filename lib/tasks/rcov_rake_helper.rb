begin
require 'rcov/rcovtask'
require 'rspec/core'
require 'rspec/core/rake_task'

rescue LoadError
  puts 'load error here'
  #allow rake to continue to function is rcov gem is not installed
  nil
end


  def index_base_path
    (ENV['CC_BUILD_ARTIFACTS'] || 'spec/coverage')
  end
  def default_rcov_params_for_unit
    '-o spec/coverage/unit -i "app\/reports" -x "app\/controllers","app\/metal",'+global_exclude
  end

  def default_rcov_params_for_functional
    '-o spec/coverage/functional  -x  "app\/reports","app\/models","app\/mailers","app\/helpers","lib/",'+global_exclude
  end

  def default_rcov_params_for_integration
    '-o spec/coverage/integration -x "features\/",' + global_exclude
  end

  def specs_corresponding_to_unit
    %w( models helpers lib reports mailers ).collect{|e| "spec/#{e}/**/*_spec.rb"}
  end

  def specs_corresponding_to_functional
    #maybe add views later
    %w( controllers routing metal).collect{|e| "spec/#{e}/**/*_spec.rb"}

  end

  def specs_corresponding_to_integration
    "stories/all.rb"

  end

  def global_exclude
    '"rubygems/","\/Applications\/","\/Library\/","spec\/","stories\/","gem\/ruby\/1.8\/gems\/","' +"#{ENV['GEM_HOME']}" + '"'

  end

  def remove_coverage_data
    rm_f "coverage.data"
  end


RCOV_OPTS=""
