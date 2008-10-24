require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomFlagsController do
  it_should_behave_like "an authenticated controller"

  def mock_custom_flag(stubs={})
    @mock_custom_flag ||= mock_model(CustomFlag, stubs)
  end

  def mock_student(stubs={})
    @mock_student ||= mock_model(Student,stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all custom_flags as @custom_flags" do
      CustomFlag.should_receive(:find).with(:all).and_return([mock_custom_flag])
      get :index
      assigns[:custom_flags].should == [mock_custom_flag]
    end

    describe "with mime type of xml" do
  
      it "should render all custom_flags as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        CustomFlag.should_receive(:find).with(:all).and_return(custom_flags = mock("Array of CustomFlags"))
        custom_flags.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested custom_flag as @custom_flag" do
      CustomFlag.should_receive(:find).with("37").and_return(mock_custom_flag)
      get :show, :id => "37"
      assigns[:custom_flag].should equal(mock_custom_flag)
    end
    
    describe "with mime type of xml" do

      it "should render the requested custom_flag as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        CustomFlag.should_receive(:find).with("37").and_return(mock_custom_flag)
        mock_custom_flag.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new custom_flag as @custom_flag" do
      CustomFlag.should_receive(:new).and_return(mock_custom_flag)
      get :new
      assigns[:custom_flag].should equal(mock_custom_flag)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested custom_flag as @custom_flag" do
      CustomFlag.should_receive(:find).with("37").and_return(mock_custom_flag)
      get :edit, :id => "37"
      assigns[:custom_flag].should equal(mock_custom_flag)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created custom_flag as @custom_flag" do
        CustomFlag.should_receive(:new).with({'these' => 'params'}).and_return(mock_custom_flag(:save => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        post :create, :custom_flag => {:these => 'params'}
        assigns(:custom_flag).should equal(mock_custom_flag)
      end

      it "should redirect to the created custom_flag" do
        CustomFlag.stub!(:new).and_return(mock_custom_flag(:save => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        post :create, :custom_flag => {}
        response.should redirect_to(student_url(1))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved custom_flag as @custom_flag" do
        CustomFlag.stub!(:new).with({'these' => 'params'}).and_return(mock_custom_flag(:save => false))
        post :create, :custom_flag => {:these => 'params'}
        assigns(:custom_flag).should equal(mock_custom_flag)
      end

      it "should re-render the 'new' template" do
        CustomFlag.stub!(:new).and_return(mock_custom_flag(:save => false))
        post :create, :custom_flag => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested custom_flag" do
        CustomFlag.should_receive(:find).with("37").and_return(mock_custom_flag)
        mock_custom_flag.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :custom_flag => {:these => 'params'}
      end

      it "should expose the requested custom_flag as @custom_flag" do
        CustomFlag.stub!(:find).and_return(mock_custom_flag(:update_attributes => true))
        put :update, :id => "1"
        assigns(:custom_flag).should equal(mock_custom_flag)
      end

      it "should redirect to the custom_flag" do
        CustomFlag.stub!(:find).and_return(mock_custom_flag(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(custom_flag_url(mock_custom_flag))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested custom_flag" do
        CustomFlag.should_receive(:find).with("37").and_return(mock_custom_flag)
        mock_custom_flag.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :custom_flag => {:these => 'params'}
      end

      it "should expose the custom_flag as @custom_flag" do
        CustomFlag.stub!(:find).and_return(mock_custom_flag(:update_attributes => false))
        put :update, :id => "1"
        assigns(:custom_flag).should equal(mock_custom_flag)
      end

      it "should re-render the 'edit' template" do
        CustomFlag.stub!(:find).and_return(mock_custom_flag(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested custom_flag" do
      CustomFlag.should_receive(:find).with("37").and_return(mock_custom_flag(:student_id => 1))
      mock_custom_flag.should_receive(:destroy)
      controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
      delete :destroy, {:id => "37"},{:selected_students=>[1]}
    end
  
    it "should redirect to the student profile" do
      CustomFlag.stub!(:find).and_return(mock_custom_flag(:destroy => true, :student_id => 1))
      controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
      delete :destroy, {:id => "1"},{:selected_students=>[1]}
      response.should redirect_to(student_url(1))
    end

  end

end
