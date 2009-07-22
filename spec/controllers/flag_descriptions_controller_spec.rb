require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagDescriptionsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_flag_description(stubs={})
    @mock_flag_description ||= mock_model(FlagDescription, stubs)
  end

  before do
    controller.stub!(:current_district=>@district=mock_district)

  end
  
  describe "GET index" do
    it "assigns all flag_descriptions as @flag_descriptions" do
      FlagDescription.should_receive(:find).with(:first, :conditions=>{:district_id =>@district.id}).and_return(mock_flag_description)
      get :index
      response.should render_template(:edit)
      assigns[:flag_description].should == mock_flag_description
    end
  end

  describe "POST create" do
    it 'should call update' do
      #controller.should_receive(:update).and_return(true)
    end
   
  end

  describe "PUT udpate" do
    before do
      FlagDescription.should_receive(:find).with(:first, :conditions=>{:district_id =>@district.id}).and_return(@fd=mock_flag_description)
    end
    
    describe "with valid params" do
      it "updates the requested flag_description" do
        @fd.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :flag_description => {:these => 'params'}
      end

      it "assigns the requested flag_description as @flag_description" do
        @fd.stub!(:update_attributes => true)
        put :update, :id => "1"
        assigns[:flag_description].should equal(mock_flag_description)
      end

      it "redirects to the root url" do
        @fd.stub!(:update_attributes => true)
        put :update, :id => "1"
        response.should redirect_to(root_url)
      end
    end
    
    describe "with invalid params" do
      it "assigns the flag_description as @flag_description" do
        @fd.stub!(:update_attributes => false)
        put :update, :id => "1"
        assigns[:flag_description].should equal(mock_flag_description)
      end

      it "re-renders the 'edit' template" do
        @fd.stub!(:update_attributes => false)
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end


end
