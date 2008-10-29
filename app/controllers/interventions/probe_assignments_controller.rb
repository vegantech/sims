class Interventions::ProbeAssignmentsController < ApplicationController

  before_filter :load_intervention
  
  def index
    @intervention_probe_assignments = @intervention.intervention_probe_assignments.prepare_all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @intervention_probe_assignments }
    end
  end

  def create
    @intervention_probe_assignment = InterventionProbeAssignment.new(param[:intervention_probe_assignment])

    respond_to do |format|
      if @intervention_probe_assignment.save
        flash[:notice] = 'InterventionProbeAssignment was successfully created.'
        format.html { redirect_to(intervention_probe_assignment_url(@intervention,@intervention_probe_assignment)) }
        format.xml  { render :xml => @intervention_probe_assignment, :status => :created, :location => @intervention_probe_assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervention_probe_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  protected
  def load_intervention
    @intervention=current_student.interventions.find(params[:intervention_id])
  end
end
