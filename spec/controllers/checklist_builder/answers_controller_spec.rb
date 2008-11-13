require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ChecklistBuilder::AnswersController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  #Delete these examples and add some real ones
  it "should use ChecklistBuilder::AnswersController" do
    controller.should be_an_instance_of(ChecklistBuilder::AnswersController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      pending
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      pending
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      pending
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      pending
      get 'edit'
      response.should be_success
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
