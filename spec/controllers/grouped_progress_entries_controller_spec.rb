require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupedProgressEntriesController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  before do
    controller.stub!(current_user: current_user)
    controller.stub!(search_criteria: search_criteria)
  end

  def search_criteria
    {search: true}
  end

  def current_user
    @current_user ||= mock_user
  end

  def mock_grouped_progress_entry(stubs={})
    @mock_grouped_progress_entry ||= mock(GroupedProgressEntry, stubs.merge(intervention: mock_intervention,probe_definition: mock_probe_definition))
  end

  describe "GET index" do
    it "assigns all grouped_progress_entries as @grouped_progress_entries when search is present" do
      GroupedProgressEntry.should_receive(:all).with(current_user,search_criteria).and_return([mock_grouped_progress_entry])
      get :index,{},search: true
      pending
      #      assigns(:grouped_progress_entries).should == [mock_grouped_progress_entry]
    end

    it "redirects when search is absent" do
      GroupedProgressEntry.should_not_receive(:all).with(current_user,search_criteria).and_return([mock_grouped_progress_entry])
      get :index,{},{}
      response.should redirect_to(root_url)
      flash[:notice].should == "You must complete a search first"
    end

  end

  describe "GET edit" do
    it "assigns the requested grouped_progress_entry as @grouped_progress_entry" do
      GroupedProgressEntry.should_receive(:find).with(current_user,"37",search_criteria ).and_return(mock_grouped_progress_entry)
      get :edit, {id: "37"},search: true
      assigns(:grouped_progress_entry).should equal(mock_grouped_progress_entry)
      response.should render_template(:edit)
    end
  end

  describe "PUT udpate" do

    describe "with valid params" do
      it "updates the requested grouped_progress_entry" do
        GroupedProgressEntry.should_receive(:find).with(current_user,"37",search_criteria).and_return(mock_grouped_progress_entry)
        mock_grouped_progress_entry.should_receive(:update_attributes).with('these' => 'params')
        put :update, {id: "37", student_intervention: {'these'=> 'params'}}, search: true
      end

      it "assigns the requested grouped_progress_entry as @grouped_progress_entry" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(update_attributes: true))
        put :update, {id: "1"}, search: true
        assigns(:grouped_progress_entry).should equal(mock_grouped_progress_entry)
      end

      it "redirects to the grouped_progress_entry" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(update_attributes: true))
        put :update,{id: "1"}, search: true

        response.should redirect_to(grouped_progress_entries_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested grouped_progress_entry" do
        GroupedProgressEntry.should_receive(:find).with(current_user,"37",search_criteria).and_return(mock_grouped_progress_entry)
        mock_grouped_progress_entry.should_receive(:update_attributes).with('these' => 'params')
        put :update, {id: "37", student_intervention: {these: 'params'}}, search: true
      end

      it "assigns the grouped_progress_entry as @grouped_progress_entry" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(update_attributes: false))
        put :update, {id: "1"}, search: true
        assigns(:grouped_progress_entry).should equal(mock_grouped_progress_entry)
      end

      it "re-renders the 'edit' template" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(update_attributes: false))
        put :update, {id: "1"}, search: true
        response.should render_template('edit')
      end
    end

  end

  describe 'put end' do
    it 'redirects to the grouped_progress_entry index page' do
      GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry("end_interventions!" => nil))
      put :end, {id: "1"}, search: true
      response.should redirect_to(grouped_progress_entries_url)
    end

    it 'sets the flash message' do
      GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry("end_interventions!" => nil))
      put :end, {id: "1"}, search: true
      flash[:notice].should == "Interventions have been ended"
    end

    it 'calls end_interventions! with params' do
      GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry)
      mock_grouped_progress_entry.should_receive("end_interventions!").with(['1','2','3'], 'End Reason', 'Fidelity')
      put :end, {id: "1", end_intervention: [1,2,3],
                 end_reason: 'End Reason', fidelity: 'Fidelity', }, search: true
    end
  end

end
