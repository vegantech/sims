require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FileController do
  describe "route generation" do
    it "should map get to download" do
      route_for(:controller => "file", :action => "download", :filename=>'shawn').should == "/file/shawn"
    end
  end

  describe "route recognition" do
 
    it "should generate params for #show" do
      params_from(:get, "/file/shawn").should == {:controller => "file", :action => "download", :filename => "shawn"}
    end
  end
end
