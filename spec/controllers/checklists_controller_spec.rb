require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChecklistsController do
  it_should_behave_like "an authenticated controller"

  def mock_checklist(stubs={})
    @mock_checklist ||= mock_model(Checklist, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all checklists as @checklists" do
      Checklist.should_receive(:find).with(:all).and_return([mock_checklist])
      get :index
      assigns[:checklists].should == [mock_checklist]
    end

    describe "with mime type of xml" do
  
      it "should render all checklists as xml" do
    pending
        request.env["HTTP_ACCEPT"] = "application/xml"
        Checklist.should_receive(:find).with(:all).and_return(checklists = mock("Array of Checklists"))
        checklists.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested checklist as @checklist" do
    pending
      Checklist.should_receive(:find).with("37").and_return(mock_checklist)
      get :show, :id => "37"
      assigns[:checklist].should equal(mock_checklist)
    end
    
    describe "with mime type of xml" do

      it "should render the requested checklist as xml" do
    pending
        request.env["HTTP_ACCEPT"] = "application/xml"
        Checklist.should_receive(:find).with("37").and_return(mock_checklist)
        mock_checklist.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new checklist as @checklist" do
    pending
      Checklist.should_receive(:new).and_return(mock_checklist)
      get :new
      assigns[:checklist].should equal(mock_checklist)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested checklist as @checklist" do
    pending
      Checklist.should_receive(:find).with("37").and_return(mock_checklist)
      get :edit, :id => "37"
      assigns[:checklist].should equal(mock_checklist)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created checklist as @checklist" do
    pending
        Checklist.should_receive(:new).with({'these' => 'params'}).and_return(mock_checklist(:save => true))
        post :create, :checklist => {:these => 'params'}
        assigns(:checklist).should equal(mock_checklist)
      end

      it "should redirect to the created checklist" do
    pending
        Checklist.stub!(:new).and_return(mock_checklist(:save => true))
        post :create, :checklist => {}
        response.should redirect_to(checklist_url(mock_checklist))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved checklist as @checklist" do
    pending
        Checklist.stub!(:new).with({'these' => 'params'}).and_return(mock_checklist(:save => false))
        post :create, :checklist => {:these => 'params'}
        assigns(:checklist).should equal(mock_checklist)
      end

      it "should re-render the 'new' template" do
    pending
        Checklist.stub!(:new).and_return(mock_checklist(:save => false))
        post :create, :checklist => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested checklist" do
    pending
        Checklist.should_receive(:find).with("37").and_return(mock_checklist)
        mock_checklist.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :checklist => {:these => 'params'}
      end

      it "should expose the requested checklist as @checklist" do
    pending
        Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => true))
        put :update, :id => "1"
        assigns(:checklist).should equal(mock_checklist)
      end

      it "should redirect to the checklist" do
    pending
        Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(checklist_url(mock_checklist))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested checklist" do
    pending
        Checklist.should_receive(:find).with("37").and_return(mock_checklist)
        mock_checklist.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :checklist => {:these => 'params'}
      end

      it "should expose the checklist as @checklist" do
    pending
        Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => false))
        put :update, :id => "1"
        assigns(:checklist).should equal(mock_checklist)
      end

      it "should re-render the 'edit' template" do
    pending
        Checklist.stub!(:find).and_return(mock_checklist(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested checklist" do
      checklist=mock_checklist
      student=mock_student(:checklists=>mock_array(:find=>checklist))
      controller.should_receive(:current_student).twice.and_return(student)
      checklist.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the checklists list" do
      checklist=mock_checklist
      student=mock_student(:checklists=>mock_array(:find=>checklist))
      controller.should_receive(:current_student).twice.and_return(student)
      checklist.should_receive(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(student_url(student))
    end

  end

end
