class QuicklistItemsController < SchoolAdminController
  # GET /quicklist_items
  # GET /quicklist_items.xml
  def index
    @quicklist_items = current_school.quicklist_interventions
    @goals = current_district.goal_definitions
  end
  # POST /quicklist_items
  # POST /quicklist_items.xml
  def create
    current_school.quicklist_intervention_ids = params[:intervention_definition_ids]
    flash[:notice] = "Quicklist Updated"
    redirect_to schools_url
 end
end
