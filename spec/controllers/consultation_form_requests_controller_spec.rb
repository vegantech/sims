require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequestsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_consultation_form_request(stubs={})
    @mock_consultation_form_request ||= mock_model(ConsultationFormRequest, stubs)
  end
  
  describe "GET show" do
    it "assigns the requested consultation_form_request as @consultation_form_request" do
      controller.should_receive(:current_district).and_return(d=mock_district)
      ConsultationFormRequest.should_receive(:find).with("37").and_return(mock_consultation_form_request(:district=>d))
      get :show, :id => "37"
      assigns[:consultation_form_request].should equal(mock_consultation_form_request)
    end
  end

  describe "GET new" do
    it "assigns a new consultation_form_request as @consultation_form_request" do
      ConsultationFormRequest.should_receive(:new).and_return(mock_consultation_form_request)
      controller.stub_association!(:current_school, :users=>[1,2,3], :school_teams=>mock_array(:named=>['a','b']))
      get :new
      assigns[:consultation_form_request].should equal(mock_consultation_form_request)
      assigns[:users].should == [1,2,3]
      assigns[:teams].should == ['a','b']
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
        controller.stub_association!(:current_school, :users=>[1,2,3], :school_teams=>mock_array(:named=>['a','b']))
        ConsultationFormRequest.stub!(:new).with({'these' => 'params',  'requestor'=>@user, 'student' =>@student }).and_return(mock_consultation_form_request(:save => false))
        post :create, :consultation_form_request => {:these => 'params'}
        assigns[:consultation_form_request].should equal(mock_consultation_form_request)
        assigns[:users].should == [1,2,3]
        assigns[:teams].should == ['a','b']
      end

      it "re-renders the 'new' template" do
        controller.stub_association!(:current_school, :users=>[1,2,3], :school_teams=>mock_array(:named=>['a','b']))
        ConsultationFormRequest.stub!(:new).and_return(mock_consultation_form_request(:save => false))
        post :create, :consultation_form_request => {}
        response.should render_template('new')
      end
    end
    
  end

  
end
