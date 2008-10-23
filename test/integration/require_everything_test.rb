require 'test_helper'

class RequireEverythingTest < ActionController::IntegrationTest
  # fixtures :your, :models
 
  #require every rb in app
  Dir.glob(RAILS_ROOT+"/app/**/*.rb").each do |rb|
    require rb.split("app/").last
  end

  # Replace this with your real tests.
  def test_truth
    puts "This just requires all ruby files in the project so they show up in code coverage"
    assert true
  end
end
