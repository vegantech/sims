class Interventions::ProbeAssignmentsController < ApplicationController
  before_filter :load_intervention

  def index
    # need t odo something with probe definition id (that's the active one, and might need building)
    @intervention_probe_assignment = @intervention.intervention_probe_assignment(params[:probe_definition_id])
    @intervention_probe_assignments = [@intervention_probe_assignment] | @intervention.intervention_probe_assignments

    respond_to do |format|
      format.js
      format.html {redirect_to edit_intervention_url(@intervention, enter_score: true)} # index.html.erb
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
    @ipa = InterventionProbeAssignment.find_by_id(params[:id]) || @intervention.intervention_probe_assignments.build
    @ipa.attributes = params[:intervention][:intervention_probe_assignment]
    @count = params[:count].to_i
    render layout: false
  end

  protected
  def load_intervention
    @intervention ||=current_student.interventions.find(params[:intervention_id])
  end

  def set_date(obj, field,_p=params)
    ary=[params["#{field}(1i)"],params["#{field}(2i)"],params["#{field}(3i)"]]
    ary.collect!(&:to_i)
    if Date.valid_civil?(*ary)
      obj.send "#{field}=", Date.civil(*ary)
    end
  end
end
