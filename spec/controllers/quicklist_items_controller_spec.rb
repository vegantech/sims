require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuicklistItemsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_quicklist_item(stubs={})
    @mock_quicklist_item ||= mock_model(QuicklistItem, stubs)
  end

  describe "responding to GET index" do
    it "should expose all quicklist_items as @quicklist_items" do
      controller.stub_association!(:current_school,:quicklist_interventions=>[mock_quicklist_item])
      controller.stub_association!(:current_district, :goal_definitions => [])
      get :index
      assigns(:quicklist_items).should == [mock_quicklist_item]
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should redirect to the school selection screen" do
        school = mock_school
        controller.should_receive(:current_school).and_return(school)
        school.should_receive(:quicklist_intervention_ids=).with(['1','2','3'])
        post :create, :intervention_definition_ids => ['1','2','3']
        response.should redirect_to(schools_url)
      end

    end

  end

end
