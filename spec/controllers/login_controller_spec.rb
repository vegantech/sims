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
      controller.should_receive(:dropdowns)
      get :login
      assert session[:user_id] == nil
      response.should be_success
    end


  end

  describe "responding to POST login with valid credentials" do
    it "should be successful" do
      controller.should_receive(:dropdowns)
      district=mock_district(:name => 'mock_district')
      controller.stub!(:current_district).and_return(district)
      district.stub!(:users).and_return(User)
      user=mock_user(:new_record=>false,:id=>999, :fullname => 'Moc User')
      user.should_receive(:record_successful_login)
      User.should_receive(:authenticate).with('user','pass').and_return(user)
      post :login ,:username=>'user',:password=>'pass'
      session[:user_id].should == 999
      response.should redirect_to("/")
    end

  end

  describe "responding to POST login with invalid credentials" do
    it "should render the login" do
      controller.should_receive(:dropdowns)
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
      controller.should_receive(:dropdowns)
      get :logout
      response.should render_template('login')
    end
  end
end
