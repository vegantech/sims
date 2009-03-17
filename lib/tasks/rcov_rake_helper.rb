begin
  require 'rcov/rcovtask'
  require File.expand_path("vendor/plugins/rspec/lib/spec/rake/spectask")

rescue LoadError
  #allow rake to continue to function is rcov gem is not installed
end
  def default_rcov_params_for_unit   
    '-i "app\/reports" -x "app\/controllers","\/Applications\/","\/Library\/","spec\/","stories\/","gem\/ruby\/1.8\/gems\/","'+ "#{ENV['GEM_HOME']}"  + '"'

  end  
  
  def default_rcov_params_for_functional   
    ' -x  "app\/reports","app\/models","app\/helpers","lib/","\/Applications\/","\/Library\/","spec\/","stories\/","gem\/ruby\/1.8\/gems\/","' +"#{ENV['GEM_HOME']}" + '"'
  end
  
  def default_rcov_params_for_integration
    ' -x "features\/","\/Applications\/","\/Library\/","spec\/","stories\/","gem\/ruby\/1.8\/gems\/","' +"#{ENV['GEM_HOME']}" + '"'
  end

  def specs_corresponding_to_unit
    %w( models helpers lib reports ).collect{|e| "spec/#{e}/**/*_spec.rb"}
  end
  
  def specs_corresponding_to_functional
    #maybe add views later
    %w( controllers ).collect{|e| "spec/#{e}/**/*_spec.rb"}
    
  end
  
  def specs_corresponding_to_integration
    "stories/all.rb"
    
  end

  def remove_coverage_data
    rm_f "coverage.data"
  end
 

RCOV_OPTS=""
