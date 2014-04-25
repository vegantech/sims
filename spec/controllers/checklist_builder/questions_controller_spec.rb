require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ChecklistBuilder::QuestionsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  before do
    district = mock_district
    @checklist_definition = mock_checklist_definition
    controller.stub!(current_district: district)
    district.stub_association!(:checklist_definitions,find: @checklist_definition)
    @checklist_definition.stub!(question_definitions: QuestionDefinition)

  end

  describe "GET 'index'" do
    it "should be successful" do
      @checklist_definition.should_receive(:question_definitions).and_return([1,2,3])
      get 'index'
      assigns(:question_definitions).should == [1,2,3]
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      QuestionDefinition.should_receive(:find).with("37").and_return('yes')
      get 'show', id: '37'
      assigns(:question_definition).should == 'yes'
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      assigns(:question_definition).new_record?.should == true
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      QuestionDefinition.should_receive(:find).with("37").and_return('yes')
      get 'edit', id: '37'
      assigns(:question_definition).should == 'yes'
    end
  end


  describe "GET 'create'" do
    it "should be successful" do
      pending
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "should be successful" do
      pending
      get 'update'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      QuestionDefinition.should_receive(:find).with("37").and_return(mock_question_definition(:destroy => true, :has_answers? => false))
      get 'destroy' , id: '37'
      response.should redirect_to(checklist_builder_checklist_url(@checklist_definition))
    end
  end

  describe "GET 'move'" do
    it "should be successful" do
      pending
      get 'move'
      response.should be_success
    end
  end
end

