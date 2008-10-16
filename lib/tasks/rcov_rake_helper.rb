RCOV_OPTS=""
  $:.unshift (RAILS_ROOT + '/vendor/gems/rcov-0.8.1.3.0/lib')
  $:.unshift 'vendor/gems/term-ansicolor-1.0.3/lib'

  ENV['PATH']='.:' + ENV['PATH']

  require 'rcov/rcovtask'
  require File.expand_path("vendor/plugins/rspec/lib/spec/rake/spectask")

  def default_rcov_params_for_unit   
    '-i "app\/reports" -x "app\/controllers","\/Library\/","spec\/","stories\/"'

  end  
  
  def default_rcov_params_for_functional   
    ' -x  "app\/reports","app\/models","app\/helpers","lib/","\/Library\/","spec\/","stories\/"'
  end
  
  def default_rcov_params_for_integration
    ' -x "\/Library\/","spec\/","stories\/"'
  end

  def specs_corresponding_to_unit
    %w( models helpers lib ).collect{|e| "spec/#{e}/*_spec.rb"}
  end
  
  def specs_corresponding_to_functional
    %w( controllers views ).collect{|e| "spec/#{e}/*_spec.rb"}
    
  end
  
  def specs_corresponding_to_integration
    "stories/all.rb"
    
  end

  def remove_coverage_data
    rm_f "coverage.data"
  end
 

