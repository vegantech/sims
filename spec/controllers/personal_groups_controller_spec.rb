require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonalGroupsController do

  def mock_personal_group(stubs={})
    @mock_personal_group ||= mock_model(PersonalGroup, stubs)
  end
  
  describe "GET index" do
    it "assigns all personal_groups as @personal_groups" do
      PersonalGroup.should_receive(:find).with(:all).and_return([mock_personal_group])
      get :index
      assigns[:personal_groups].should == [mock_personal_group]
    end
  end

  describe "GET show" do
    it "assigns the requested personal_group as @personal_group" do
      PersonalGroup.should_receive(:find).with("37").and_return(mock_personal_group)
      get :show, :id => "37"
      assigns[:personal_group].should equal(mock_personal_group)
    end
  end

  describe "GET new" do
    it "assigns a new personal_group as @personal_group" do
      PersonalGroup.should_receive(:new).and_return(mock_personal_group)
      get :new
      assigns[:personal_group].should equal(mock_personal_group)
    end
  end

  describe "GET edit" do
    it "assigns the requested personal_group as @personal_group" do
      PersonalGroup.should_receive(:find).with("37").and_return(mock_personal_group)
      get :edit, :id => "37"
      assigns[:personal_group].should equal(mock_personal_group)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created personal_group as @personal_group" do
        PersonalGroup.should_receive(:new).with({'these' => 'params'}).and_return(mock_personal_group(:save => true))
        post :create, :personal_group => {:these => 'params'}
        assigns[:personal_group].should equal(mock_personal_group)
      end

      it "redirects to the created personal_group" do
        PersonalGroup.stub!(:new).and_return(mock_personal_group(:save => true))
        post :create, :personal_group => {}
        response.should redirect_to(personal_group_url(mock_personal_group))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved personal_group as @personal_group" do
        PersonalGroup.stub!(:new).with({'these' => 'params'}).and_return(mock_personal_group(:save => false))
        post :create, :personal_group => {:these => 'params'}
        assigns[:personal_group].should equal(mock_personal_group)
      end

      it "re-renders the 'new' template" do
        PersonalGroup.stub!(:new).and_return(mock_personal_group(:save => false))
        post :create, :personal_group => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested personal_group" do
        PersonalGroup.should_receive(:find).with("37").and_return(mock_personal_group)
        mock_personal_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :personal_group => {:these => 'params'}
      end

      it "assigns the requested personal_group as @personal_group" do
        PersonalGroup.stub!(:find).and_return(mock_personal_group(:update_attributes => true))
        put :update, :id => "1"
        assigns[:personal_group].should equal(mock_personal_group)
      end

      it "redirects to the personal_group" do
        PersonalGroup.stub!(:find).and_return(mock_personal_group(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(personal_group_url(mock_personal_group))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested personal_group" do
        PersonalGroup.should_receive(:find).with("37").and_return(mock_personal_group)
        mock_personal_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :personal_group => {:these => 'params'}
      end

      it "assigns the personal_group as @personal_group" do
        PersonalGroup.stub!(:find).and_return(mock_personal_group(:update_attributes => false))
        put :update, :id => "1"
        assigns[:personal_group].should equal(mock_personal_group)
      end

      it "re-renders the 'edit' template" do
        PersonalGroup.stub!(:find).and_return(mock_personal_group(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested personal_group" do
      PersonalGroup.should_receive(:find).with("37").and_return(mock_personal_group)
      mock_personal_group.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the personal_groups list" do
      PersonalGroup.stub!(:find).and_return(mock_personal_group(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(personal_groups_url)
    end
  end

end
