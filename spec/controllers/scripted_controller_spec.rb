require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScriptedController do

  #Delete these examples and add some real ones
  it "should use ScriptedController" do
    controller.should be_an_instance_of(ScriptedController)
  end

  describe "automated_intervention" do

    before(:each) do
      user='automated_intervention'
      pw='automated_intervention'
      @auto_user=Factory(:user,:username=>user,:password=>pw,:first_name=>'automated', :last_name => 'intervention',:email=>'test@test.com')
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "GET" do
      it 'should be successful' do
        get 'automated_intervention',:district_abbrev => @auto_user.district.abbrev
        response.should_not render_template("layouts/application")
        response.should be_success
      end
    end

    describe "POST" do
      it 'should render check to check email' do
        AutomatedIntervention.should_receive(:new).with('test',@auto_user).and_return(
        mock(:import => 'These are the messages'))
        Notifications.should_receive(:deliver_district_upload_results).with('These are the messages', @auto_user.email)
        post 'automated_intervention', :district_abbrev => @auto_user.district.abbrev, :upload_file => 'test'


        response.should be_success
        response.body.should == "response will be emailed to #{@auto_user.email}"
      end
    end

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
