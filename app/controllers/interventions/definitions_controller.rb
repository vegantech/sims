class Interventions::DefinitionsController < ApplicationController
  include PopulateInterventionDropdowns
 
  def index
    populate_goals
  end

  
  def select
    respond_to do |format|
      format.html {redirect_to new_intervention_url(:intervention=>{:intervention_definition_id=>1})}
      format.js {
        populate_intervention
     }
    end
  end

end


