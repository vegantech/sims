require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScriptedController do

  #Delete these examples and add some real ones
  it "should use ScriptedController" do
    controller.should be_an_instance_of(ScriptedController)
  end


  describe "GET 'referral_report'" do
    it "should be successful" do
      pending
      get 'referral_report'
      response.should be_success
    end
  end

  describe "GET 'district_upload'" do
    it "should be successful" do
      pending
      get 'district_upload'
      response.should be_success
    end
  end
end
