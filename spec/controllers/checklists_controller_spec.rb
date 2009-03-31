require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChecklistsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_checklist(stubs={})
    @mock_checklist ||= mock_model(Checklist, stubs)
  end

  before do
    controller.stub!(:current_student =>@current_student=mock_student, :current_user =>@current_user=mock_user)
    @current_student.stub!(:checklists=>Checklist)
    
  end
  
  describe "responding to GET show" do

    it "should expose the requested checklist as @checklist" do
      @current_student.should_receive(:find_checklist).with("37").and_return(mock_checklist)
      get :show, :id => "37"
      assigns[:checklist].should equal(mock_checklist)
    end

    it "should set the flash if the checklist isn't found" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      @current_student.should_receive(:find_checklist).with("37").and_return(nil)
      get :show, :id => "37"
      assigns[:checklist].should be_nil
      flash[:notice].should == "Checklist no longer exists."
      response.should redirect_to(:back)
    end
    
   
  end

  describe "responding to GET new" do
  
    it "should expose a new checklist as @checklist" do
      Checklist.should_receive(:new_from_teacher).with(@current_user).and_return(mock_checklist('pending?'=>false,'missing_checklist_definition?'=>false))
      get :new
      assigns[:checklist].should equal(mock_checklist)
    end

    it 'should redirect to current student if there is a checklist in progress' do
      Checklist.should_receive(:new_from_teacher).with(@current_user).and_return(mock_checklist('pending?'=>true,'missing_checklist_definition?'=>false))
      get :new
      flash[:notice].should == "Please submit/edit or delete the already started checklist first"
      response.should redirect_to(student_url(@current_student))
    end

    it 'should redirect to current_student if there is no checklist defined' do
      Checklist.should_receive(:new_from_teacher).with(@current_user).and_return(mock_checklist('pending?'=>false,'missing_checklist_definition?'=>true))
      get :new
      flash[:notice].should == "No checklist available.  Have the content builder create one."
      response.should redirect_to(student_url(@current_student))
    end

  end

  describe "responding to GET edit" do
   it "should expose the requested checklist as @checklist" do
      @current_student.should_receive(:find_checklist).with("37").and_return(mock_checklist)
      get :edit, :id => "37"
      assigns[:checklist].should equal(mock_checklist)
    end

    it "should set the flash if the checklist isn't found" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      @current_student.should_receive(:find_checklist).with("37").and_return(nil)
      get :edit, :id => "37"
      assigns[:checklist].should be_nil
      flash[:notice].should == "Checklist no longer exists."
      response.should redirect_to(:back)
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
      @current_student.should_receive(:find_checklist).with("37",false).and_return(mc=mock_checklist)
      mc.should_receive(:destroy)
      get :destroy, :id => "37"
      response.should redirect_to(student_url(@current_student))
    end

    it "should set the flash if the checklist isn't found" do
      @current_student.should_receive(:find_checklist).with("37",false).and_return(nil)
      get :destroy, :id => "37"
      response.should redirect_to(student_url(@current_student))
    end
 

 
  end

end
