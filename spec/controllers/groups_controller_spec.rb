require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  def mock_group(stubs = {})
    @mock_group ||= mock_model(Group, stubs)
  end

  before do
    @mock_school = mock_school(groups: Group)
    controller.stub!(current_school: @mock_school)
  end

  describe "responding to GET index" do

    it "should expose all groups as @groups" do
      Group.should_receive(:paged_by_title).and_return(g = [mock_group])
      g.stub!(:out_of_bounds? => false)
      get :index
      assigns(:groups).should == [mock_group]
    end


  end

  describe "responding to GET show" do

    it "should expose the requested group as @group" do
      Group.should_receive(:find).with("37").and_return(mock_group)
      get :show, id: "37"
      assigns(:group).should equal(mock_group)
    end


  end

  describe "responding to GET new" do

    it "should expose a new group as @group" do
      Group.should_receive(:new).and_return(mock_group)
      get :new
      assigns(:group).should equal(mock_group)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested group as @group" do
      Group.should_receive(:find).with("37").and_return(mock_group)
      get :edit, id: "37"
      assigns(:group).should equal(mock_group)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created group as @group" do
        Group.should_receive(:build).with({'these' => 'params'}).and_return(mock_group(save: true))
        post :create, group: {these: 'params'}
        assigns(:group).should equal(mock_group)
      end

      it "should redirect to the created group" do
        Group.stub!(:build).and_return(mock_group(save: true))
        post :create, group: {}
        response.should redirect_to(group_url(mock_group))
      end

      it "should have a link to the group in the flash" do
        Group.stub!(:build).and_return(mock_group(save: true))
        post :create, group: {}
        flash[:notice].should match(/#{edit_group_path(mock_group)}/)
      end




    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved group as @group" do
        Group.stub!(:build).with({'these' => 'params'}).and_return(mock_group(save: false))
        post :create, group: {these: 'params'}
        assigns(:group).should equal(mock_group)
      end

      it "should re-render the 'new' template" do
        Group.stub!(:build).and_return(mock_group(save: false))
        post :create, group: {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested group" do
        Group.should_receive(:find).with("37").and_return(mock_group)
        mock_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, id: "37", group: {these: 'params'}
      end

      it "should expose the requested group as @group" do
        Group.stub!(:find).and_return(mock_group(update_attributes: true))
        put :update, id: "1"
        assigns(:group).should equal(mock_group)
      end

      it "should redirect to the group" do
        Group.stub!(:find).and_return(mock_group(update_attributes: true))
        put :update, id: "1"
        response.should redirect_to(group_url(mock_group))
      end

      it "should have a link to the group in the flash" do
        Group.stub!(:find).and_return(mock_group(update_attributes: true))
        put :update, id: "1"
        flash[:notice].should match(/#{edit_group_path(mock_group)}/)
      end


    end

    describe "with invalid params" do

      it "should update the requested group" do
        Group.should_receive(:find).with("37").and_return(mock_group)
        mock_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, id: "37", group: {these: 'params'}
      end

      it "should expose the group as @group" do
        Group.stub!(:find).and_return(mock_group(update_attributes: false))
        put :update, id: "1"
        assigns(:group).should equal(mock_group)
      end

      it "should re-render the 'edit' template" do
        Group.stub!(:find).and_return(mock_group(update_attributes: false))
        put :update, id: "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested group" do
      Group.should_receive(:find).with("37").and_return(mock_group)
      mock_group.should_receive(:destroy)
      delete :destroy, id: "37"
    end

    it "should redirect to the groups list" do
      Group.stub!(:find).and_return(mock_group(destroy: true))
      delete :destroy, id: "1"
      response.should redirect_to(groups_url)
    end

  end


  describe "responding to DELETE remove_user"  do
    it "should remove the user from the group" do
      mg = mock_group
      Group.should_receive(:find).and_return(mg)
      mg.should_receive(:user_group_assignments).and_return( UserGroupAssignment)
      UserGroupAssignment.should_receive(:find).with("222").and_return(muga = mock_user_group_assignment)
      muga.should_receive(:destroy)
      delete "remove_user", id: "1", user_assignment_id: "222"
      response.should redirect_to(group_url(mg))
    end

  end


end
