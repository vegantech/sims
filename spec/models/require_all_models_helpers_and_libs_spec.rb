require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RequireAllModelsHelpersandLibsSpec < Test::Unit::TestCase
  # Replace this with your real tests.
  

  #Require everything in lib
  Dir.glob(RAILS_ROOT+"/lib/**/*.rb").each do |lib|
    require lib.split("lib/").last
  end
 
  #require every rb in app
  Dir.glob(RAILS_ROOT+"/app/models/**/*.rb").each do |rb|
    e=rb.split("app/models/").last.split(".rb").first 
    begin
      e.classify.constantize
    rescue
      require e
    end
  end
  
  Dir.glob(RAILS_ROOT+"/app/helpers/**/*.rb").each do |rb|
    e=rb.split("app/helpers/").last.split(".rb").first 
    begin
      e.classify.constantize
    rescue
      require e
    end
  end

  Dir.glob(RAILS_ROOT+"/app/reports/**/*.rb").each do |rb|
    e=rb.split("app/reports/").last.split(".rb").first 
    begin
      e.classify.constantize
    rescue
      require e
    end
  end

  # Replace this with your real tests.
  def test_truth
    #"This just requires all ruby model, helper, lib, and report files in the project so they show up in code coverage"
    assert true
  end
end
