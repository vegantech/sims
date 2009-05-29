class Interventions::ProbeAssignmentsController < ApplicationController
  before_filter :load_intervention
  additional_write_actions  'disable_all', 'preview_graph'
  
  def index
    #need t odo something with probe definition id (that's the active one, and might need building)
    @intervention_probe_assignment = @intervention.intervention_probe_assignment(params[:probe_definition_id])
    @intervention_probe_assignments = [@intervention_probe_assignment] | @intervention.intervention_probe_assignments

    respond_to do |format|
      format.js
      format.html # index.html.erb
    end
  end

  def disable_all
    @intervention.intervention_probe_assignments.each(&:disable)
    flash[:notice] = "All assigned monitors have been unassigned"

    respond_to do |format|
      format.html {redirect_to(@intervention)}
    end

  end

  def preview_graph
    if params[:id]
      @ipa = InterventionProbeAssignment.find(params[:id])
    else
      @ipa = @intervention.intervention_probe_assignments.build(:probe_definition_id=>params[:probe_definition_id])
    end

#    render :text=> params[:intervention][:intervention_probe_assignment][:new_probes].inspect and return
    @probes = @ipa.probes.build(params[:probes].values)
#    render :text => @ipa.probes.size.to_s and return
    @count = params[:count].to_i
    render :layout => false
  end

  protected
  def load_intervention
    @intervention ||=current_student.interventions.find(params[:intervention_id])
  end


end
