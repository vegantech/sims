require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ChecklistBuilder::ElementsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  before do
    district=mock_district
    @checklist_definition=mock_checklist_definition
    @question_definition=mock_question_definition
    controller.stub!(:current_district=>district)
    district.stub_association!(:checklist_definitions,:find=>@checklist_definition)
    @checklist_definition.stub_association!(:question_definitions,:find=>@question_definition)
    @question_definition.stub!(:element_definitions=>ElementDefinition)

  end

  describe "GET 'index'" do
    it "should be successful" do
      @question_definition.should_receive(:element_definitions).and_return([1,2,3])
      get 'index'
      assigns(:element_definitions).should == [1,2,3]
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      ElementDefinition.should_receive(:find).with("37").and_return('yes')
      get 'show', :id=>'37'
      assigns(:element_definition).should == 'yes'
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      ElementDefinition.should_receive(:build).and_return('yes')
      get 'new'
      assigns(:element_definition).should == 'yes'
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      ElementDefinition.should_receive(:find).with("37").and_return('yes')
      get 'edit', :id=>'37'
      assigns(:element_definition).should == 'yes'
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
      pending
      get 'destroy'
      response.should be_success
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


