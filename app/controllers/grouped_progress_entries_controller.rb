class GroupedProgressEntriesController < ApplicationController
  # GET /grouped_progress_entries
  # GET /grouped_progress_entries.xml
  def index
    @grouped_progress_entries = GroupedProgressEntry.all(current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grouped_progress_entries }
    end
  end

  # GET /grouped_progress_entries/1/edit
  def edit
    @grouped_progress_entry = GroupedProgressEntry.find(current_user,params[:id])
    @intervention = Intervention.find(@grouped_progress_entry.to_param.split("-").first)
    @probe_definition = @intervention.intervention_probe_assignment.probe_definition
  end

  # PUT /grouped_progress_entries/1
  # PUT /grouped_progress_entries/1.xml
  def update
    @grouped_progress_entry = GroupedProgressEntry.find(current_user,params[:id])
    @intervention = Intervention.find(@grouped_progress_entry.to_param.split("-").first)
    @probe_definition = @intervention.intervention_probe_assignment.probe_definition
    

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

end
