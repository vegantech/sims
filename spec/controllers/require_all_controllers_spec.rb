require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'

#Converting this to a spec didn't work
class RequireAllControllersTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  


  #require every rb in app
  Dir.glob(RAILS_ROOT+"/app/controllers/**/*.rb").each do |rb|
    e=rb.split("app/controllers/").last.split(".rb").first
    begin
      if e == "application"
        ApplicationController
      else
        e.classify.constantize
      end
    rescue
      require e
    end
  end
 





  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
