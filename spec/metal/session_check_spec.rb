require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

=begin
class ApiController
  include ActionController::UrlFor
  include ActionController::Testing
  include Rails.application.routes.url_helpers
  include ActionController::Compatibility
end
=end

require 'rack/test'
describe SessionCheck do
  include Rack::Test::Methods

  describe 'call' do
    before do
      @dummy_return = [200, {}, "Call to dummy app"]
      @dummy_app = lambda { |env| [200, {}, "Call to dummy app"] }
    end

    it 'should return 404 (and thus call dummy app) if not session check' do
      SessionCheck.new(@dummy_app).call({}).should == @dummy_return
    end

    it 'should return 200 if session check' do
      sc=SessionCheck.new(@dummy_app)
      SessionCheck.any_instance.should_receive(:check).and_return("Yes it worked")
      sc.call({"PATH_INFO" => "/session_check"}).should == [200, {"Content-Type" => "text/html"}, ["Yes it worked"]]
    end
  end

  describe 'check' do
    it 'should test different combinations of user and session'
  end

end

