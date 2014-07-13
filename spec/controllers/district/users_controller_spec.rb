require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::UsersController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  def mock_user(stubs={})
    @mock_user ||= mock_model(User,stubs.merge(:first_name => 'Mock', :last_name => 'User', :to_s => 'Mock User'))
  end

  before do
    @district = mock_district(:schools => [])
    controller.stub!(:current_district => @district)
    @district.stub!(:users => User)
  end

  describe "responding to GET index" do
    before do
      @district.stub_association!(:users,:paged_by_last_name=>users=[mock_user])
      users.stub!(:out_of_bounds? => false)
    end

    it "should expose all users as @users" do
      get :index
      assigns(:users).should == [mock_user]
    end

  end

  describe "responding to GET new" do
    it "should expose a new user as @user" do
      User.should_receive(:build).and_return(mock_user)
      mock_user.should_receive(:roles=).with('regular_user')

      get :new
      assigns(:user).should equal(mock_user)
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested user as @user" do
      User.should_receive(:find).with("37").and_return(mock_user)
      get :edit, :id => "37"
      assigns(:user).should equal(mock_user)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      let(:user) {mock_model(User, :save => true)}
      it "should expose a newly created user as @user" do
        User.should_receive(:build).with({'these' => 'params'}).and_return(user)
        post :create, :user => {:these => 'params'}
        assigns(:user).should equal(user)
      end

      it "should redirect to the created user" do
        User.stub!(:build).and_return(user)
        post :create, :user => {}
        response.should redirect_to(district_users_url)
      end

      it "should should set the flash with a link back to edit the created user" do
        User.stub!(:build).and_return user
        post :create, :user => {}
        flash[:notice].should match(/#{edit_district_user_path(user)}/)
      end
    end

    describe "with invalid params" do
      let(:user) {mock_model(User, :save => false)}
      it "should expose a newly created but unsaved user as @user" do
        User.stub!(:build).with({'these' => 'params'}).and_return(user)
        post :create, :user => {:these => 'params'}
        assigns(:user).should equal(user)
      end

      it "should re-render the 'new' template" do
        User.stub!(:build).and_return(user)
        post :create, :user => {}
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      let(:user) {mock_model(User, :update_attributes => true, :to_s => "udpate user")}
      it "should update the requested user" do
        User.should_receive(:find).with("37").and_return(user)
        user.should_receive(:update_attributes).with({"these"=>"params"})
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "should expose the requested user as @user" do
        User.stub!(:find).and_return user
        put :update, :id => "1"
        assigns(:user).should equal(user)
      end

      it "should redirect to the user" do
        User.stub!(:find).and_return user
        put :update, :id => "1"
        response.should redirect_to(district_users_url)
      end

      describe "when editing self" do
        it 'should keep the user logged in' do
          User.stub!(:find).and_return user
          controller.stub!(:current_user => user)
          controller.should_receive(:sign_in)
          put :update, :id => "1"
        end

        it 'should not sign the lsa in as someone else' do
          User.stub!(:find).and_return user
          controller.stub!(:current_user => User.new)
          controller.should_not_receive(:sign_in)
          put :update, :id => "1"
        end
      end

      describe 'with staff assignments' do
        before(:each) do
          User.stub!(:find).and_return(user)
        end

        def user_string
          "<a href=\"#{edit_district_user_path(user)}\">#{user}</a>"
        end

        it 'should set the flash when complete when there have been no staff assignment changes' do
          put :update, :id => "1"
          flash[:notice].should == "#{user_string} was successfully updated."
        end

        it 'should set the flash when complete when are still staff assignments' do
          @district.should_receive(:staff_assignments).and_return([1,2,3])
          put :update, :id => "1", :user => {:staff_assignments_attributes => []}
          flash[:notice].should == "#{user_string} was successfully updated."

        end

        it 'should append a message to the flash if the staff assignments have been emptied' do
          @district.should_receive(:staff_assignments).and_return([])
          put :update, :id => "1", :user => {:staff_assignments_attributes => []}
          flash[:notice].should == "#{user_string} was successfully updated.  All staff assignments have been removed, upload a new staff_assignments.csv if you want to use this feature."

        end
      end
    end

    describe "with invalid params" do
      let(:user) {mock_model(User, :update_attributes => false, :to_s => "udpate user")}
      it "should update the requested user" do
        User.should_receive(:find).with("37").and_return(user)
        user.should_receive(:update_attributes).with({"these"=>"params"})
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "should expose the user as @user" do
        User.stub!(:find).and_return user
        put :update, :id => "1"
        assigns(:user).should equal(user)
      end

      it "should re-render the 'edit' template" do
        User.stub!(:find).and_return user
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested user" do
      User.should_receive(:find).with("37").and_return(mock_user)
      mock_user.should_receive(:remove_from_district)
      delete :destroy, :id => "37"
    end

    it "should redirect to the users list" do
      user = mock_model(User, :remove_from_district => true)
      User.stub!(:find).and_return user
      delete :destroy, :id => "1"
      response.should redirect_to(district_users_url)
    end
  end
end
