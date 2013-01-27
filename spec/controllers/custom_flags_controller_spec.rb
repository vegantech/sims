require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomFlagsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_custom_flag(stubs={})
    @mock_custom_flag ||= mock_model(CustomFlag, stubs)
  end

  def mock_student(stubs={})
    @mock_student ||= mock_model(Student,stubs)
  end

  describe "responding to GET new" do

    it "should expose a new custom_flag as @custom_flag" do
      CustomFlag.should_receive(:new).and_return(mock_custom_flag)
      get :new
      assigns(:custom_flag).should equal(mock_custom_flag)
    end

  end
  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created custom_flag as @custom_flag" do
        CustomFlag.should_receive(:new).with({'these' => 'params'}).and_return(mock_custom_flag(:save => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        post :create, :custom_flag => {:these => 'params'}
        assigns(:custom_flag).should equal(mock_custom_flag)
      end

      it "should redirect to the created custom_flag" do
        CustomFlag.stub!(:new).and_return(mock_custom_flag(:save => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        post :create, :custom_flag => {}
        response.should redirect_to(student_url(1))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved custom_flag as @custom_flag" do
        CustomFlag.stub!(:new).with({'these' => 'params'}).and_return(mock_custom_flag(:save => false))
        post :create, :custom_flag => {:these => 'params'}
        assigns(:custom_flag).should equal(mock_custom_flag)
      end

      it "should re-render the 'new' template" do
        CustomFlag.stub!(:new).and_return(mock_custom_flag(:save => false))
        post :create, :custom_flag => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to DELETE destroy" do
    before do
      controller.should_receive(:current_student).twice.and_return(mock_student(:id=>1, 'new_record?'=>false,:custom_flags=>CustomFlag))

    end

    it "should destroy the requested custom_flag" do
      CustomFlag.should_receive(:find).with("37").and_return(mock_custom_flag(:student_id => 1))
      mock_custom_flag.should_receive(:destroy)
      delete :destroy, {:id => "37"}
    end

    it "should redirect to the student profile" do
      CustomFlag.stub!(:find).and_return(mock_custom_flag(:destroy => true, :student_id => 1))
      delete :destroy, {:id => "1"}
      response.should redirect_to(student_url(1))
    end

  end

end
