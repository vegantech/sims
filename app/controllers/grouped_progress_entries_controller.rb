class GroupedProgressEntriesController < ApplicationController
  # GET /grouped_progress_entries
  # GET /grouped_progress_entries.xml
  def index
    @grouped_progress_entries = GroupedProgressEntry.all(current_user,search_criteria)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grouped_progress_entries }
    end
  end

  # GET /grouped_progress_entries/1/edit
  def edit
    @grouped_progress_entry = GroupedProgressEntry.find(current_user,params[:id],search_criteria)
    @intervention = @grouped_progress_entry.intervention
    @probe_definition = @grouped_progress_entry.probe_definition
  end

  # PUT /grouped_progress_entries/1
  # PUT /grouped_progress_entries/1.xml
  def update
    @grouped_progress_entry = GroupedProgressEntry.find(current_user,params[:id],search_criteria)
    @intervention = @grouped_progress_entry.intervention
    @probe_definition = @grouped_progress_entry.probe_definition

    respond_to do |format|
      if @grouped_progress_entry.update_attributes(params[:student_intervention])
        flash[:notice] = 'Scores and Comments were successfully entered.'
        format.html { redirect_to(grouped_progress_entries_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grouped_progress_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def search_criteria
    session[:search].merge(
      :school_id => current_school_id,
      :user => current_user)
  end

end
