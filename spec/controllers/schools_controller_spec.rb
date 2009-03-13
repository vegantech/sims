require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  describe 'index' do
    it 'should set @schools instance variable' do
      controller.stub_association!(:current_user,:authorized_schools =>[1,2,3])
      get :index
      assigns(:schools).should == [1,2,3]
    end

    it "should redirect to root_url and set flash if there aren't any authorized schools" do
      controller.stub_association!(:current_user,:authorized_schools =>[])
      get :index
      flash[:notice].should == "No schools available"
      response.should redirect_to(root_url)
    end
  end

  describe 'select' do
    before do
      @user=mock_user
      @school=mock_school(:id=>99, :name=>"Greta Elementary")
      controller.should_receive(:current_user).and_return(@user)

    end
    it 'should set the session if the selected school is found' do
      @user.should_receive(:authorized_schools).with("99").and_return([@school])
      post :select, :school=>{:id=>"99"}
      session[:school_id].should == 99
      flash[:notice].should == "Greta Elementary Selected"
      response.should redirect_to(search_students_url)
      

    end

    it "should not set a flash message if the school isn't found" do
      @user.should_receive(:authorized_schools).with("99").and_return([])
      post :select, :school=>{:id=>"99"}
      session[:school_id].should == nil
      flash[:notice].should be_nil
      response.should redirect_to(search_students_url)
    end

  end

end
