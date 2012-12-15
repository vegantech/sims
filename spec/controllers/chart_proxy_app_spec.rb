require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ChartProxyApp
  include ActionController::UrlFor
  include ActionController::Testing
  include Rails.application.routes.url_helpers
end

describe ChartProxyApp do
  describe 'index' do
    it 'should proxy the request to google' do
      controller.stub(:env => {'QUERY_STRING' => 'woowoo'})
      Net::HTTP.should_receive(:get).with('chart.apis.google.com', "/chart?woowoo").and_return('google_return')
      result = get :index
      result.body.should == "google_return"
      result.headers['Content-Disposition'].should == 'inline'
      result.content_type.should == 'image/png'
    end
  end
end
