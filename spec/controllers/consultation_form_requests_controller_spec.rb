require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequestsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_consultation_form_request(stubs={})
    @mock_consultation_form_request ||= mock_model(ConsultationFormRequest, stubs)
  end
  
  describe "GET index" do
    it "assigns all consultation_form_requests as @consultation_form_requests" do
      ConsultationFormRequest.should_receive(:find).with(:all).and_return([mock_consultation_form_request])
      get :index
      assigns[:consultation_form_requests].should == [mock_consultation_form_request]
    end
  end

  describe "GET show" do
    it "assigns the requested consultation_form_request as @consultation_form_request" do
      ConsultationFormRequest.should_receive(:find).with("37").and_return(mock_consultation_form_request)
      get :show, :id => "37"
      assigns[:consultation_form_request].should equal(mock_consultation_form_request)
    end
  end

  describe "GET new" do
    it "assigns a new consultation_form_request as @consultation_form_request" do
      ConsultationFormRequest.should_receive(:new).and_return(mock_consultation_form_request)
      get :new
      assigns[:consultation_form_request].should equal(mock_consultation_form_request)
    end
  end

  describe "GET edit" do
    it "assigns the requested consultation_form_request as @consultation_form_request" do
      ConsultationFormRequest.should_receive(:find).with("37").and_return(mock_consultation_form_request)
      get :edit, :id => "37"
      assigns[:consultation_form_request].should equal(mock_consultation_form_request)
    end
  end

  describe "POST create" do
    before do
      @student=mock_student
      @user = mock_user
      controller.stub!(:current_student=>@student, :current_user => @user)
    end
    
    describe "with valid params" do
      it "assigns a newly created consultation_form_request as @consultation_form_request" do
        ConsultationFormRequest.should_receive(:new).with({'these' => 'params', 'requestor'=>@user, 'student' =>@student }).and_return(mock_consultation_form_request(:save => true))
        post :create, :consultation_form_request => {:these => 'params'}
        assigns[:consultation_form_request].should equal(mock_consultation_form_request)
      end

      it "redirects to the created consultation_form_request" do
        ConsultationFormRequest.stub!(:new).and_return(mock_consultation_form_request(:save => true))
        post :create, :consultation_form_request => {}, :format => 'html'
        response.should redirect_to(student_url(@student))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved consultation_form_request as @consultation_form_request" do
        ConsultationFormRequest.stub!(:new).with({'these' => 'params',  'requestor'=>@user, 'student' =>@student }).and_return(mock_consultation_form_request(:save => false))
        post :create, :consultation_form_request => {:these => 'params'}
        assigns[:consultation_form_request].should equal(mock_consultation_form_request)
      end

      it "re-renders the 'new' template" do
        ConsultationFormRequest.stub!(:new).and_return(mock_consultation_form_request(:save => false))
        post :create, :consultation_form_request => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested consultation_form_request" do
        ConsultationFormRequest.should_receive(:find).with("37").and_return(mock_consultation_form_request)
        mock_consultation_form_request.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :consultation_form_request => {:these => 'params'}
      end

      it "assigns the requested consultation_form_request as @consultation_form_request" do
        ConsultationFormRequest.stub!(:find).and_return(mock_consultation_form_request(:update_attributes => true))
        put :update, :id => "1"
        assigns[:consultation_form_request].should equal(mock_consultation_form_request)
      end

      it "redirects to the consultation_form_request" do
        ConsultationFormRequest.stub!(:find).and_return(mock_consultation_form_request(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(consultation_form_request_url(mock_consultation_form_request))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested consultation_form_request" do
        ConsultationFormRequest.should_receive(:find).with("37").and_return(mock_consultation_form_request)
        mock_consultation_form_request.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :consultation_form_request => {:these => 'params'}
      end

      it "assigns the consultation_form_request as @consultation_form_request" do
        ConsultationFormRequest.stub!(:find).and_return(mock_consultation_form_request(:update_attributes => false))
        put :update, :id => "1"
        assigns[:consultation_form_request].should equal(mock_consultation_form_request)
      end

      it "re-renders the 'edit' template" do
        ConsultationFormRequest.stub!(:find).and_return(mock_consultation_form_request(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested consultation_form_request" do
      ConsultationFormRequest.should_receive(:find).with("37").and_return(mock_consultation_form_request)
      mock_consultation_form_request.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the consultation_form_requests list" do
      ConsultationFormRequest.stub!(:find).and_return(mock_consultation_form_request(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(consultation_form_requests_url)
    end
  end

end
