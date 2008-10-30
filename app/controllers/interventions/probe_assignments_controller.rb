class Interventions::ProbeAssignmentsController < ApplicationController

  before_filter :load_intervention
  
  def index
    @intervention_probe_assignments = @intervention.intervention_probe_assignments.prepare_all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def create
    raise "FAIL"
#    @intervention_probe_assignment = InterventionProbeAssignment.new(param[:intervention_probe_assignment])
#
#    respond_to do |format|
#      if @intervention_probe_assignment.save
#        flash[:notice] = 'InterventionProbeAssignment was successfully created.'
#        format.html { redirect_to(intervention_probe_assignment_url(@intervention,@intervention_probe_assignment)) }
#      else
#        format.html { render :action => "new" }
#      end
#    end
  end

  protected
  def load_intervention
    @intervention ||=current_student.interventions.find(params[:intervention_id])
  end
end
