require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendationsController do
  it_should_behave_like "an authenticated controller"

  #Delete these examples and add some real ones
  it "should use RecommendationsController" do
    controller.should be_an_instance_of(RecommendationsController)
  end

  def mock_checklist(stubs={})
    @mock_checklist ||= mock_model(Checklist,stubs.merge(:build_recommendation=>mock_recommendation))
  end

  def mock_student(stubs={})
    @mock_student ||= mock_model(Student,stubs.merge(:checklists=>mock_checklist))
  end

  def mock_recommendation(stubs={})
    @mock_recommendation ||= mock_model(Recommendation,stubs.merge( "set_reason_from_previous!"=>true))
  end

  describe "GET 'new'" do
    it "should be successful" do
      controller.should_receive(:current_student).and_return(mock_student)
      mock_checklist.should_receive(:find).and_return(mock_checklist)
      mock_checklist.should_receive(:build_recommendation).and_return(mock_recommendation)
      get 'new',:checklist_id=>2
      assigns(:recommendation).should equal(mock_recommendation)
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful if valid" do
      controller.should_receive(:current_student).twice.and_return(mock_student)
      controller.should_receive(:current_user).and_return(1)
      mock_checklist.should_receive(:find).and_return(mock_checklist)
      mock_checklist.should_receive(:build_recommendation).and_return(mock_recommendation)
      mock_recommendation.should_receive(:save).and_return(true)
      post 'create' ,:checklist_id=>2, :recommendation=>{}
      response.should redirect_to(student_url(mock_student))
    end

     it "should be render new it doesn't save" do
      controller.should_receive(:current_user).and_return(1)
      controller.should_receive(:current_student).and_return(mock_student)
      mock_checklist.should_receive(:find).and_return(mock_checklist)
      mock_checklist.should_receive(:build_recommendation).and_return(mock_recommendation)
      mock_recommendation.should_receive(:save).and_return(false)
      post 'create' , :checklist_id => 2, :recommendation=>{}
      response.should render_template("new")
    end
  end

end
