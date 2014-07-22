class Interventions::ProbesController < ApplicationController
  before_filter :load_intervention,:load_intervention_probe_assignment, except: :index

  def index
    @intervention=current_student.interventions.find(params[:intervention_id],include: {intervention_probe_assignments: [:probe_definition,:probes]})
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    @probe = @intervention_probe_assignment.probes.build

    respond_to do |format|
      format.js
      format.html # new.html.erb
    end
  end

  def edit
    @probe = @intervention_probe_assignment.probes.find(params[:id])
  end

  def create
    @probe = @intervention_probe_assignment.probes.new(params[:probe])

    respond_to do |format|
      if @probe.save
        flash[:notice] = 'Score was successfully created.'
        format.html { redirect_to(@intervention) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @probe = @intervention_probe_assignment.probes.find(params[:id])

    respond_to do |format|
      if @probe.update_attributes(params[:probe])
        flash.now[:notice] = 'Probe was successfully updated.'
        format.html { } # redirect_to(@intervention) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @probe = @intervention_probe_assignment.probes.find(params[:id])
    @probe.destroy

    respond_to do |format|
      format.js {}
      format.html { redirect_to(probes_url(@intervention,@intervention_probe_assignment)) }
    end
  end

  protected
  def load_intervention
    @intervention=current_student.interventions.find(params[:intervention_id])
  end

  def load_intervention_probe_assignment
    pdi = params[:probe_assignment_id].to_s
    if pdi.include?("pd")
      @intervention_probe_assignment = @intervention.intervention_probe_assignments.build(probe_definition_id: pdi.sub(/^pd/,''))
    else
      @intervention_probe_assignment = @intervention.intervention_probe_assignments.find(pdi)
    end
  end
end
