require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoSchoolDaysController do

  def mock_cico_school_day(stubs={})
    @mock_cico_school_day ||= mock_model(CicoSchoolDay, stubs)
  end
  
  describe "GET index" do
    it "assigns all cico_school_days as @cico_school_days" do
      CicoSchoolDay.should_receive(:find).with(:all).and_return([mock_cico_school_day])
      get :index
      assigns[:cico_school_days].should == [mock_cico_school_day]
    end
  end

  describe "GET show" do
    it "assigns the requested cico_school_day as @cico_school_day" do
      CicoSchoolDay.should_receive(:find).with("37").and_return(mock_cico_school_day)
      get :show, :id => "37"
      assigns[:cico_school_day].should equal(mock_cico_school_day)
    end
  end

  describe "GET new" do
    it "assigns a new cico_school_day as @cico_school_day" do
      CicoSchoolDay.should_receive(:new).and_return(mock_cico_school_day)
      get :new
      assigns[:cico_school_day].should equal(mock_cico_school_day)
    end
  end

  describe "GET edit" do
    it "assigns the requested cico_school_day as @cico_school_day" do
      CicoSchoolDay.should_receive(:find).with("37").and_return(mock_cico_school_day)
      get :edit, :id => "37"
      assigns[:cico_school_day].should equal(mock_cico_school_day)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created cico_school_day as @cico_school_day" do
        CicoSchoolDay.should_receive(:new).with({'these' => 'params'}).and_return(mock_cico_school_day(:save => true))
        post :create, :cico_school_day => {:these => 'params'}
        assigns[:cico_school_day].should equal(mock_cico_school_day)
      end

      it "redirects to the created cico_school_day" do
        CicoSchoolDay.stub!(:new).and_return(mock_cico_school_day(:save => true))
        post :create, :cico_school_day => {}
        response.should redirect_to(cico_school_day_url(mock_cico_school_day))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved cico_school_day as @cico_school_day" do
        CicoSchoolDay.stub!(:new).with({'these' => 'params'}).and_return(mock_cico_school_day(:save => false))
        post :create, :cico_school_day => {:these => 'params'}
        assigns[:cico_school_day].should equal(mock_cico_school_day)
      end

      it "re-renders the 'new' template" do
        CicoSchoolDay.stub!(:new).and_return(mock_cico_school_day(:save => false))
        post :create, :cico_school_day => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested cico_school_day" do
        CicoSchoolDay.should_receive(:find).with("37").and_return(mock_cico_school_day)
        mock_cico_school_day.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cico_school_day => {:these => 'params'}
      end

      it "assigns the requested cico_school_day as @cico_school_day" do
        CicoSchoolDay.stub!(:find).and_return(mock_cico_school_day(:update_attributes => true))
        put :update, :id => "1"
        assigns[:cico_school_day].should equal(mock_cico_school_day)
      end

      it "redirects to the cico_school_day" do
        CicoSchoolDay.stub!(:find).and_return(mock_cico_school_day(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(cico_school_day_url(mock_cico_school_day))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested cico_school_day" do
        CicoSchoolDay.should_receive(:find).with("37").and_return(mock_cico_school_day)
        mock_cico_school_day.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cico_school_day => {:these => 'params'}
      end

      it "assigns the cico_school_day as @cico_school_day" do
        CicoSchoolDay.stub!(:find).and_return(mock_cico_school_day(:update_attributes => false))
        put :update, :id => "1"
        assigns[:cico_school_day].should equal(mock_cico_school_day)
      end

      it "re-renders the 'edit' template" do
        CicoSchoolDay.stub!(:find).and_return(mock_cico_school_day(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested cico_school_day" do
      CicoSchoolDay.should_receive(:find).with("37").and_return(mock_cico_school_day)
      mock_cico_school_day.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the cico_school_days list" do
      CicoSchoolDay.stub!(:find).and_return(mock_cico_school_day(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(cico_school_days_url)
    end
  end

end
