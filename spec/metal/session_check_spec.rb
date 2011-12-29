require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

=begin
class ApiController
  include ActionController::UrlFor
  include ActionController::Testing
  include Rails.application.routes.url_helpers
  include ActionController::Compatibility
end
=end

describe SessionCheck do
  describe 'call' do
    it 'should return 404 if not session check' do
      SessionCheck.call({}).should == [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end

    it 'should return 200 if session check' do
      SessionCheck.should_receive(:check).and_return("Yes it worked")
      SessionCheck.call({"PATH_INFO" => "/session_check"}).should == [200, {"Content-Type" => "text/html"}, ["Yes it worked"]]
    end
  end

  describe 'check' do
    it 'should test different combinations of user and session'
  end

end

