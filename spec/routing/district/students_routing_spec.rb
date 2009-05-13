require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::StudentsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "district/students", :action => "index").should == "/district/students"
    end
  
    it "should map #new" do
      route_for(:controller => "district/students", :action => "new").should == "/district/students/new"
    end
  
    it "should map #show" do
      route_for(:controller => "district/students", :action => "show", :id => "1").should == "/district/students/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "district/students", :action => "edit", :id => "1").should == "/district/students/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "district/students", :action => "update", :id => "1").should == {:path => "/district/students/1", :method => :put}
    end
  
    it "should map #destroy" do
      route_for(:controller => "district/students", :action => "destroy", :id => "1").should == {:path => "/district/students/1", :method => :delete}
    end

    it 'should map #bulk_import_form' do
      route_for(:controller => 'district/students', :action => 'bulk_import_form').should == {:path => '/district/students/bulk_import_form', :method => :get}
    end

    it 'should map #bulk_import' do
      route_for(:controller => 'district/students', :action => 'bulk_import').should == {:path => '/district/students/bulk_import', :method => :post}
    end

    
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/district/students").should == {:controller => "district/students", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/district/students/new").should == {:controller => "district/students", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/district/students").should == {:controller => "district/students", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/district/students/1").should == {:controller => "district/students", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/district/students/1/edit").should == {:controller => "district/students", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/district/students/1").should == {:controller => "district/students", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/district/students/1").should == {:controller => "district/students", :action => "destroy", :id => "1"}
    end

    it 'should generate params for #bulk_import_form' do
      params_from(:get, '/district/students/bulk_import_form').should == {:controller => 'district/students', :action => 'bulk_import_form'}
    end

    it 'should generate params for #bulk_import' do
      params_from(:post, '/district/students/bulk_import').should == {:controller => 'district/students', :action => 'bulk_import'}
    end

  end
end
