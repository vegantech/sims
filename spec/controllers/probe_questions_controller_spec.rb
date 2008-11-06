require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeQuestionsController do
  it_should_behave_like "an authenticated controller"

  def mock_probe_question(stubs={})
    @mock_probe_question ||= mock_model(ProbeQuestion, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all probe_questions as @probe_questions" do
      ProbeQuestion.should_receive(:find).with(:all).and_return([mock_probe_question])
      get :index
      assigns[:probe_questions].should == [mock_probe_question]
    end

    describe "with mime type of xml" do
  
      it "should render all probe_questions as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProbeQuestion.should_receive(:find).with(:all).and_return(probe_questions = mock("Array of ProbeQuestions"))
        probe_questions.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested probe_question as @probe_question" do
      ProbeQuestion.should_receive(:find).with("37").and_return(mock_probe_question)
      get :show, :id => "37"
      assigns[:probe_question].should equal(mock_probe_question)
    end
    
    describe "with mime type of xml" do

      it "should render the requested probe_question as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProbeQuestion.should_receive(:find).with("37").and_return(mock_probe_question)
        mock_probe_question.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new probe_question as @probe_question" do
      ProbeQuestion.should_receive(:new).and_return(mock_probe_question)
      get :new
      assigns[:probe_question].should equal(mock_probe_question)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested probe_question as @probe_question" do
      ProbeQuestion.should_receive(:find).with("37").and_return(mock_probe_question)
      get :edit, :id => "37"
      assigns[:probe_question].should equal(mock_probe_question)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created probe_question as @probe_question" do
        ProbeQuestion.should_receive(:new).with({'these' => 'params'}).and_return(mock_probe_question(:save => true))
        post :create, :probe_question => {:these => 'params'}
        assigns(:probe_question).should equal(mock_probe_question)
      end

      it "should redirect to the created probe_question" do
        ProbeQuestion.stub!(:new).and_return(mock_probe_question(:save => true))
        post :create, :probe_question => {}
        response.should redirect_to(probe_question_url(mock_probe_question))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved probe_question as @probe_question" do
        ProbeQuestion.stub!(:new).with({'these' => 'params'}).and_return(mock_probe_question(:save => false))
        post :create, :probe_question => {:these => 'params'}
        assigns(:probe_question).should equal(mock_probe_question)
      end

      it "should re-render the 'new' template" do
        ProbeQuestion.stub!(:new).and_return(mock_probe_question(:save => false))
        post :create, :probe_question => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested probe_question" do
        ProbeQuestion.should_receive(:find).with("37").and_return(mock_probe_question)
        mock_probe_question.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :probe_question => {:these => 'params'}
      end

      it "should expose the requested probe_question as @probe_question" do
        ProbeQuestion.stub!(:find).and_return(mock_probe_question(:update_attributes => true))
        put :update, :id => "1"
        assigns(:probe_question).should equal(mock_probe_question)
      end

      it "should redirect to the probe_question" do
        ProbeQuestion.stub!(:find).and_return(mock_probe_question(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(probe_question_url(mock_probe_question))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested probe_question" do
        ProbeQuestion.should_receive(:find).with("37").and_return(mock_probe_question)
        mock_probe_question.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :probe_question => {:these => 'params'}
      end

      it "should expose the probe_question as @probe_question" do
        ProbeQuestion.stub!(:find).and_return(mock_probe_question(:update_attributes => false))
        put :update, :id => "1"
        assigns(:probe_question).should equal(mock_probe_question)
      end

      it "should re-render the 'edit' template" do
        ProbeQuestion.stub!(:find).and_return(mock_probe_question(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested probe_question" do
      ProbeQuestion.should_receive(:find).with("37").and_return(mock_probe_question)
      mock_probe_question.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the probe_questions list" do
      ProbeQuestion.stub!(:find).and_return(mock_probe_question(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(probe_questions_url)
    end

  end

end
