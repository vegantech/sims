require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_consultation_form(stubs={})
    @mock_consultation_form ||= mock_model(ConsultationForm, stubs)
  end
  
  describe "GET index" do
    it "assigns all consultation_forms as @consultation_forms" do
      ConsultationForm.should_receive(:find).with(:all).and_return([mock_consultation_form])
      get :index
      assigns[:consultation_forms].should == [mock_consultation_form]
    end
  end

  describe "GET show" do
    it "assigns the requested consultation_form as @consultation_form" do
      ConsultationForm.should_receive(:find).with("37").and_return(mock_consultation_form)
      get :show, :id => "37"
      assigns[:consultation_form].should equal(mock_consultation_form)
    end
  end

  describe "GET new" do
    it "assigns a new consultation_form as @consultation_form" do
      ConsultationForm.should_receive(:new).and_return(mock_consultation_form)
      get :new
      assigns[:consultation_form].should equal(mock_consultation_form)
    end
  end

  describe "GET edit" do
    it "assigns the requested consultation_form as @consultation_form" do
      ConsultationForm.should_receive(:find).with("37").and_return(mock_consultation_form)
      get :edit, :id => "37"
      assigns[:consultation_form].should equal(mock_consultation_form)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created consultation_form as @consultation_form" do
        ConsultationForm.should_receive(:new).with({'these' => 'params'}).and_return(mock_consultation_form(:save => true))
        mock_consultation_form.stub!(:user= => true, :student= =>true)
        post :create, :consultation_form => {:these => 'params'}
        assigns[:consultation_form].should equal(mock_consultation_form)
      end

      it "redirects to the student" do
        ConsultationForm.stub!(:new).and_return(mock_consultation_form(:save => true))
        controller.stub!(:current_student => m=mock_student )
        mock_consultation_form.stub!(:user= => true, :student= =>true)
        post :create, :consultation_form => {}, :format=>'html'
        response.should redirect_to(student_url(m))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved consultation_form as @consultation_form" do
        ConsultationForm.stub!(:new).with({'these' => 'params'}).and_return(mock_consultation_form(:save => false))
        mock_consultation_form.stub!(:user= => true, :student= =>true)
        post :create, :consultation_form => {:these => 'params'}
        assigns[:consultation_form].should equal(mock_consultation_form)
      end

      it "re-renders the 'new' template" do
        ConsultationForm.stub!(:new).and_return(mock_consultation_form(:save => false))
        mock_consultation_form.stub!(:user= => true, :student= =>true)
        post :create, :consultation_form => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested consultation_form" do
        ConsultationForm.should_receive(:find).with("37").and_return(mock_consultation_form)
        mock_consultation_form.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :consultation_form => {:these => 'params'}
      end

      it "assigns the requested consultation_form as @consultation_form" do
        ConsultationForm.stub!(:find).and_return(mock_consultation_form(:update_attributes => true))
        put :update, :id => "1"
        assigns[:consultation_form].should equal(mock_consultation_form)
      end

      it "redirects to the consultation_form" do
        ConsultationForm.stub!(:find).and_return(mock_consultation_form(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(consultation_form_url(mock_consultation_form))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested consultation_form" do
        ConsultationForm.should_receive(:find).with("37").and_return(mock_consultation_form)
        mock_consultation_form.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :consultation_form => {:these => 'params'}
      end

      it "assigns the consultation_form as @consultation_form" do
        ConsultationForm.stub!(:find).and_return(mock_consultation_form(:update_attributes => false))
        put :update, :id => "1"
        assigns[:consultation_form].should equal(mock_consultation_form)
      end

      it "re-renders the 'edit' template" do
        ConsultationForm.stub!(:find).and_return(mock_consultation_form(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested consultation_form" do
      ConsultationForm.should_receive(:find).with("37").and_return(mock_consultation_form)
      mock_consultation_form.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the consultation_forms list" do
      ConsultationForm.stub!(:find).and_return(mock_consultation_form(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(consultation_forms_url)
    end
  end

end
