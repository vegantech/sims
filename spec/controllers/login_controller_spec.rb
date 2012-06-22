require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginController do
  before(:each) do
    controller.should_not_receive(:authenticate)
  end



  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "responding to GET index" do

    it "should call the login method and render the login template" do
      controller.should_receive(:login).and_return(true)
      get :index
      response.should render_template('login')
    end

  end

  describe "responding to GET login" do
    it "should be successful" do
      get :login
      assert session[:user_id] == nil
      response.should be_success
    end


  end

  describe "responding to POST login with valid credentials" do
    it "should be successful" do
      district=mock_district(:name => 'mock_district')
      controller.stub!(:current_district).and_return(district)
      district.stub!(:users).and_return(User)
      user=mock_user(:new_record=>false,:id=>999, :fullname => 'Moc User')
      user.should_receive(:record_successful_login)
      User.should_receive(:authenticate).with('user','pass').and_return(user)
      post :login ,:username=>'user',:password=>'pass'
      session[:user_id].should == 999
      response.should redirect_to("http://www.test.host/")
    end

    it 'should set a flash message if a login token is created' do
      controller.stub(:current_district => District.new)
      User.should_receive(:new).and_return(mock_user( :token => 'token', :new_record? => true))
      post :login, :username => 'user'
      request.flash[:notice].should == "An email has been sent, follow the link to change your password."
    end

    describe 'forgot password' do
      it 'should set the flash if the district has forgot_password disabled' do
        controller.stub(:current_district => District.new(:forgot_password => false))
        post :login, :username => 'user', :forgot_password => true
        request.flash[:notice].should == "This district does not support password recovery.  Contact your LSA for assistance"
      end

      it 'should  set the flash if the user has no email' do
        controller.stub(:current_district => District.new(:forgot_password => true))
        User.should_receive(:new).and_return(mock_user( :email? => nil))
        post :login, :username => 'user', :forgot_password => 'true'
        request.flash[:notice].should == "User does not have email assigned in SIMS.  Contact your LSA for assistance"
      end

      it 'should create the token if the user has email and the district has forgot password enabled' do
        controller.stub(:current_district => District.new(:forgot_password => true))
        User.should_receive(:new).and_return(m=mock_user( :email? => true, :create_token => true))
        post :login, :username => 'user', :forgot_password => 'true'
        request.flash[:notice].should == 'An email has been sent, follow the link to change your password.'
      end


    end
  end

  describe "responding to POST login with invalid credentials" do
    it "should render the login" do
      district=mock_district(:name => 'mock district')
      controller.stub!(:current_district).and_return(district)
      district.stub!(:users).and_return(User)
      district.stub!(:logs).and_return(DistrictLog)
      User.should_receive(:authenticate).and_return(false)
      post :login
      session[:user_id].should == nil
      request.flash[:notice].should == "Authentication Failure"
      response.should render_template("login")
    end

  end

  describe "responding to GET logout" do
    it "should reset the session and redirect to root" do
      controller.should_receive(:reset_session)
      get :logout
      response.should render_template('login')
    end
  end

  describe "change_password" do
    describe "get" do
      it 'should have specs'
    end

    describe "put" do
      it 'should have specs'
    end
  end
end
