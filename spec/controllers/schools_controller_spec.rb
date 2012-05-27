require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolsController do
  include_context "authorized"
  include_context "authenticated"

  describe 'index' do
    describe 'with a single school' do
      let(:user) { mock_user(:schools =>[mock_school(:id=>'MOCK SCHOOL', :name => 'Mock Elementary')], :authorized_for? => true) }
      before do
        controller.stub!(:current_user => user)
      end


      it 'should automatically redirect if the user when the flash is not already set'  do
        get :index
        session[:school_id].should == 'MOCK SCHOOL'
        flash[:notice].should == 'Mock Elementary has been automatically selected.'
        response.should redirect_to(search_students_url)
      end

      it 'should render if the students page is not authorized' do
        user.should_receive(:authorized_for?).with('students').and_return(false)
        get :index
        session[:school_id].should == 'MOCK SCHOOL'
        flash[:notice].should == 'Mock Elementary has been automatically selected.'
        response.should redirect_to(not_authorized_url)

      end
      it 'should not redirect if the flash was previously set' do
        flash = {:notice =>"Exists"}
        controller.should_receive(:flash).and_return(flash)
        get :index
        flash[:notice].should == 'Exists'
        response.should_not redirect_to(search_students_url)
        pending "Why did I do this?  Redirect loop or preserving the flash?"

      end


    end
    it 'should set @schools instance variable' do
      controller.stub_association!(:current_user,:schools =>[1,2,3], :authorized_for? => true)
      get :index
      assigns(:schools).should == [1,2,3]
    end

    it "should redirect to root_url and set flash if there aren't any authorized schools" do
      controller.stub_association!(:current_user,:schools =>[])
      get :index
      flash[:notice].should == "No schools available"
      response.should redirect_to(not_authorized_url)
    end
  end

  describe 'select' do
    before do
      @user=mock_user(:authorized_for? => true)
      @school=mock_school(:id=>99, :name=>"Greta Elementary")
      controller.stub!(:current_user =>@user)
      School.stub!(:find => @school)

    end
    it 'should set the session if the selected school is found' do
      @user.should_receive(:schools).and_return(School)
      post :select, :school=>{:id=>"99"}
      session[:school_id].should == 99
      flash[:notice].should == "Greta Elementary Selected"
      response.should redirect_to(search_students_url)
    end

    it 'should redirect to the main page if the user does not have access to students' do
      @user.should_receive(:schools).and_return(School)
      @user.should_receive(:authorized_for?).and_return(false)
      post :select, :school=>{:id=>"99"}
      session[:school_id].should == 99
      flash[:notice].should == "Greta Elementary Selected"
      response.should redirect_to(not_authorized_url)
    end

    it "should not set a flash message if the school isn't found" do
      @user.should_receive(:schools).and_return(mock_school(:find => nil))
      post :select, :school=>{:id=>"99"}
      session[:school_id].should == nil
      flash[:notice].should be_nil
      response.should redirect_to(search_students_url)
    end

  end

end
