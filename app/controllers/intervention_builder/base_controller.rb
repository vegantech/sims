class InterventionBuilder::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :regenerate_intervention_pdfs
  helper_method :move_path
  cache_sweeper :intervention_builder_sweeper

  def regenerate_intervention_pdfs
    current_district.objective_definitions.each(&:touch)
    current_district.touch
    #these are now generated upon request
    #CreateInterventionPdfs.generate(current_district)
    redirect_to :back
  end

  def interventions_without_recommended_monitors
    @int_defs = InterventionDefinition.find(:all,:include => [:recommended_monitors,{:intervention_cluster=>{:objective_definition=>:goal_definition}}], :conditions => ["recommended_monitors.id is null and goal_definitions.district_id = ?", current_district.id])
  end

end
