require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sims::BestStandardsSupport, :type => :request do
  it 'should have p3p header' do
    get "/"
    response.headers["p3p"].should == 'CP = "CAO PSA OUR"'
  end

  it 'should have XUA compat header' do
    get "/"
    response.headers["X-UA-Compatible"].should == 'IE=Edge,chrome=IE7'
  end
end

