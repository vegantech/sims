require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::SchoolsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  def mock_schools(stubs = {})
    @mock_schools ||= mock_model(School, stubs)
  end

  before do
    @district = mock_district(users: [])
    @district.stub_association!(:users, size: 10)
    controller.stub!(current_district: @district)
    @district.stub!(schools: School)
  end

  describe "responding to GET index" do
    it "should expose all district_schools as @schools" do
      @district.should_receive(:schools).and_return([mock_schools])
      get :index
      assigns(:schools).should == [mock_schools]
    end
  end

  describe "responding to GET new" do
    it "should expose a new schools as @school" do
      School.should_receive(:build).and_return(mock_schools)
      get :new
      assigns(:school).should equal(mock_schools)
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested schools as @schools" do
      School.should_receive(:find).with("37").and_return(mock_schools)
      get :edit, id: "37"
      assigns(:school).should equal(mock_schools)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created schools as @schools" do
        School.should_receive(:build).with({'these' => 'params'}).and_return(mock_schools(save: true))
        post :create, school: {these: 'params'}
        assigns(:school).should equal(mock_schools)
      end

      it "should redirect to the created schools" do
        School.stub!(:build).and_return(mock_schools(save: true))
        post :create, school: {}
        response.should redirect_to(district_schools_url)
      end

      it "should set the flash with a link back to the newschool" do
        School.stub!(:build).and_return(mock_schools(save: true))
        post :create, school: {}
        flash[:notice].should match(/#{edit_district_school_path(mock_schools)}/)
      end


    end
    describe "with invalid params" do
      it "should expose a newly created but unsaved schools as @schools" do
        School.stub!(:build).with({'these' => 'params'}).and_return(mock_schools(save: false))
        post :create, school: {these: 'params'}
        assigns(:school).should equal(mock_schools)
      end

      it "should re-render the 'new' template" do
        School.stub!(:build).and_return(mock_schools(save: false))
        post :create, school: {}
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested schools" do
        School.should_receive(:find).with("37").and_return(mock_schools)
        mock_schools.should_receive(:update_attributes).with({"these" => "params"})
        put :update, id: "37", school: {these: 'params'}
      end

      it "should expose the requested schools as @schools" do
        School.stub!(:find).and_return(mock_schools(update_attributes: true))
        put :update, id: "1"
        assigns(:school).should equal(mock_schools)
      end

      it "should redirect to the schools" do
        School.stub!(:find).and_return(mock_schools(update_attributes: true))
        put :update, id: "1"
        response.should redirect_to(district_schools_url)
      end

      it "should set the flash with a link back to the school" do
        School.stub!(:find).and_return(mock_schools(update_attributes: true))
        put :update, id: "1"
        flash[:notice].should match(/#{edit_district_school_path(mock_schools)}/)
      end


    end
    describe "with invalid params" do
      it "should update the requested schools" do
        School.should_receive(:find).with("37").and_return(mock_schools)
        mock_schools.should_receive(:update_attributes).with({"these" => "params"})
        put :update, id: "37", school: {these: 'params'}
      end

      it "should expose the schools as @schools" do
        School.stub!(:find).and_return(mock_schools(update_attributes: false))
        put :update, id: "1"
        assigns(:school).should equal(mock_schools)
      end

      it "should re-render the 'edit' template" do
        School.stub!(:find).and_return(mock_schools(update_attributes: false))
        put :update, id: "1"
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested schools" do
      School.should_receive(:find).with("37").and_return(mock_schools)
      mock_schools.should_receive(:destroy)
      delete :destroy, id: "37"
    end

    it "should redirect to the district_schools list" do
      School.stub!(:find).and_return(mock_schools(destroy: true))
      delete :destroy, id: "1"
      response.should redirect_to(district_schools_url)
    end
  end
end
