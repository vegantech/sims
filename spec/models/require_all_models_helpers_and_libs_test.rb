require 'test_helper'

class RequireAllModelsHelpersandLibsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  

  #Require everything in lib
  Dir.glob(RAILS_ROOT+"/lib/**/*.rb").each do |lib|
    require lib.split("lib/").last
  end
 
  #require every rb in app
  Dir.glob(RAILS_ROOT+"/app/models/**/*.rb").each do |rb|
    require rb.split("app/").last
  end
  
  Dir.glob(RAILS_ROOT+"/app/helpers/**/*.rb").each do |rb|
    require rb.split("app/").last
  end

  Dir.glob(RAILS_ROOT+"/app/reports/**/*.rb").each do |rb|
    require rb.split("app/").last
  end






  # Replace this with your real tests.
  def test_truth
    puts "This just requires all ruby model, helper, lib, and report files in the project so they show up in code coverage"
    assert true
  end
end
