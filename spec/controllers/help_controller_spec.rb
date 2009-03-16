require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HelpController do

  #Delete this example and add some real ones
  it "should use HelpController" do
    controller.should be_an_instance_of(HelpController)
  end

  describe 'show' do
    it 'should sanitize the param' do
      get :show, :id=>"../../dog"
      assigns(:file).should == "%2F%2Fdog"

    end
  end

end
