require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolsController do
  include_context "authorized"
  include_context "authenticated"

  describe 'index' do
    describe 'with a single school' do
      let(:school) {mock_school(id: 'MOCK SCHOOL', name: 'Mock Elementary')}
      let(:user) { mock_user(:schools => [school], :authorized_for? => true) }
      before do
        controller.stub!(current_user: user)
      end


      it 'should automatically redirect if the user when the flash is not already set'  do
        controller.stub!(current_school: school)
        get :index
        session[:school_id].should == 'MOCK SCHOOL'
        flash[:notice].should == ' Mock Elementary has been automatically selected.'
        response.should redirect_to([school,StudentSearch])
      end

      it 'should render if the students page is not authorized' do
        user.should_receive(:authorized_for?).with('students').and_return(false)
        get :index
        session[:school_id].should == 'MOCK SCHOOL'
        flash[:notice].should == ' Mock Elementary has been automatically selected.'
        response.should redirect_to(not_authorized_url)

      end
      it 'should not redirect if the flash has tag backs to prevent redirect loop' do
        flash = {tag_back: "Exists"}
        controller.stub!(flash: flash)
        controller.stub!(current_school: school)
        get :index
        flash[:notice].should == ' Mock Elementary has been automatically selected.'
        response.should_not redirect_to(school_student_search_url(school))
      end


    end
    it 'should set @schools instance variable' do
      controller.stub_association!(:current_user,:schools => [1,2,3], :authorized_for? => true)
      get :index
      assigns(:schools).should == [1,2,3]
    end

    it "should redirect to root_url and set flash if there aren't any authorized schools" do
      controller.stub_association!(:current_user,schools: [])
      get :index
      flash[:notice].should == "No schools available"
      response.should redirect_to(not_authorized_url)
    end
  end

  describe 'select' do
    before do
      @user = mock_user(:authorized_for? => true)
      @school = mock_school(id: 99, name: "Greta Elementary")
      controller.stub!(current_user: @user)
      School.stub!(find: @school)

    end
    it 'should set the session if the selected school is found' do
      @user.should_receive(:schools).and_return(School)
      post :create, school: {id: "99"}
      session[:school_id].should == 99
      flash[:notice].should == "Greta Elementary Selected"
      response.should redirect_to([@school,StudentSearch])
    end

    it 'should redirect to the main page if the user does not have access to students' do
      @user.should_receive(:schools).and_return(School)
      @user.should_receive(:authorized_for?).and_return(false)
      post :create, school: {id: "99"}
      session[:school_id].should == 99
      flash[:notice].should == "Greta Elementary Selected"
      response.should redirect_to(not_authorized_url)
    end

    it "should not set a flash message if the school isn't found" do
      controller.stub!(current_school: @school)
      @user.should_receive(:schools).and_return(mock_school(find: nil))
      post :create, school: {id: "99"}
      session[:school_id].should == nil
      flash[:notice].should be_nil
      response.should redirect_to([@school,StudentSearch])
      pending "This seems wrong, if there is no school, then how would it go to search"
    end

  end

end
