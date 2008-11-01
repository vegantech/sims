class Interventions::ProbesController < ApplicationController
  before_filter :load_intervention,:load_intervention_probe_assignment
  
  def index
    @probes = @intervention_probe_assignment.probes

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @probe = @intervention_probe_assignment.probes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @probe = @intervention_probe_assignment.probes.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @probe = @intervention_probe_assignment.probes.find(params[:id])
  end

  def create
    @probe = @intervention_probe_assignment.probes.new

    respond_to do |format|
      if @probe.save
        flash[:notice] = 'Probe was successfully created.'
        format.html { redirect_to(probe_url(@intervention,@intervention_probe_assignment,@probe)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @probe = @intervention_probe_assignment.probes.find(params[:id])

    respond_to do |format|
      if @probe.update_attributes(params[:probe])
        flash[:notice] = 'Probe was successfully updated.'
        format.html { redirect_to(probe_url(@intervention,@intervention_probe_assignment,@probe)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @probe = @intervention_probe_assignment.probes.find(params[:id])
    @probe.destroy

    respond_to do |format|
      format.html { redirect_to(probes_url(@intervention,@intervention_probe_assignment)) }
    end
  end


  protected
  def load_intervention
    @intervention=current_student.interventions.find(params[:intervention_id])
  end

  def load_intervention_probe_assignment
    @intervention_probe_assignment = @intervention.intervention_probe_assignments.find(params[:intervention_probe_assignment_id])
  end

end
