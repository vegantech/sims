require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_consultation_form(stubs={})
    @mock_consultation_form ||= mock_model(ConsultationForm, stubs)
  end
  
  describe "GET show" do
    it "assigns the requested consultation_form as @consultation_form" do
      controller.should_receive(:current_district).and_return(d=mock_district)
      ConsultationForm.should_receive(:find).with("37").and_return(mock_consultation_form(:district=>d))
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

end
