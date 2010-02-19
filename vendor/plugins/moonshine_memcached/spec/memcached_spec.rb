require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class MemcachedManifest < Moonshine::Manifest::Rails
  plugin :memcached
end

describe "A manifest with the Memcached plugin" do
  
  before do
    @manifest = MemcachedManifest.new
    @manifest.memcached
  end

  it "should install the memcached package" do
    @manifest.packages.keys.should include('memcached')
  end

  it "should configure and run the memcached service" do
    @manifest.services.keys.should include('memcached')
    @manifest.services['memcached'].ensure.should == :running
  end

  it "should allow running service at boot to be disabled" do
    @manifest.services['memcached'].enable.should == true
    @manifest.memcached(:enable_on_boot => false)
    @manifest.services['memcached'].enable.should_not == true
  end

  it "should install the memcached configuration file" do
    @manifest.files['/etc/memcached.conf'].should_not be(nil)
  end

  it "should install the Ruby client library for memcached iff the option is given" do
    @manifest.packages.keys.should_not include('memcache-client')

    # stub so Gem ignores what you really have installed locally
    Gem.stub_chain(:source_index, :search => [])
    @manifest.memcached(:client => '1.7.2')
    @manifest.packages.keys.should include('memcache-client')
    @manifest.packages['memcache-client'].ensure.should == '1.7.2'
  end
  
end