require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupedProgressEntriesController do

  def mock_grouped_progress_entry(stubs={})
    @mock_grouped_progress_entry ||= mock_model(GroupedProgressEntry, stubs)
  end
  
  describe "GET index" do
    it "assigns all grouped_progress_entries as @grouped_progress_entries" do
      GroupedProgressEntry.should_receive(:find).with(:all).and_return([mock_grouped_progress_entry])
      get :index
      assigns[:grouped_progress_entries].should == [mock_grouped_progress_entry]
    end
  end

  describe "GET edit" do
    it "assigns the requested grouped_progress_entry as @grouped_progress_entry" do
      GroupedProgressEntry.should_receive(:find).with("37").and_return(mock_grouped_progress_entry)
      get :edit, :id => "37"
      assigns[:grouped_progress_entry].should equal(mock_grouped_progress_entry)
    end
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested grouped_progress_entry" do
        GroupedProgressEntry.should_receive(:find).with("37").and_return(mock_grouped_progress_entry)
        mock_grouped_progress_entry.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :grouped_progress_entry => {:these => 'params'}
      end

      it "assigns the requested grouped_progress_entry as @grouped_progress_entry" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(:update_attributes => true))
        put :update, :id => "1"
        assigns[:grouped_progress_entry].should equal(mock_grouped_progress_entry)
      end

      it "redirects to the grouped_progress_entry" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(grouped_progress_entry_url(mock_grouped_progress_entry))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested grouped_progress_entry" do
        GroupedProgressEntry.should_receive(:find).with("37").and_return(mock_grouped_progress_entry)
        mock_grouped_progress_entry.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :grouped_progress_entry => {:these => 'params'}
      end

      it "assigns the grouped_progress_entry as @grouped_progress_entry" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(:update_attributes => false))
        put :update, :id => "1"
        assigns[:grouped_progress_entry].should equal(mock_grouped_progress_entry)
      end

      it "re-renders the 'edit' template" do
        GroupedProgressEntry.stub!(:find).and_return(mock_grouped_progress_entry(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

end
