class PrincipalOverridesController < ApplicationController

  # GET /principal_overrides
  def index
    @principal_overrides = current_user.grouped_principal_overrides

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /principal_overrides/new
  def new
    @principal_override = current_user.principal_override_requests.build(student: current_student)

    respond_to do |format|
      format.html # new.html.erb
      format.js  { }
    end
  end

  # GET /principal_overrides/1/edit
  # Principal response
  def edit
    @principal_override = PrincipalOverride.find(params[:id])
    @tiers = current_district.tiers
    @principal_override.setup_response_for_edit(params[:response]) #accept or reject
  end

  # POST /principal_overrides
  def create
    @principal_override = current_user.principal_override_requests.build(params[:principal_override].merge(student: current_student))

    respond_to do |format|
      if @principal_override.save
        flash[:notice] = 'PrincipalOverride was successfully created and sent'
        format.html { redirect_to(current_student) }
        format.js   {}
      else
        format.html { render action: "new" }
        format.js   { render action: "new" }
      end
    end
  end

  # PUT /principal_overrides/1
  def update
    @principal_override = PrincipalOverride.find(params[:id])

    respond_to do |format|
      if @principal_override.update_attributes(params[:principal_override].merge(principal_id: current_user.id))
        flash[:notice] = 'PrincipalOverride was successfully updated.'
        format.html { redirect_to(principal_overrides_url) }
        format.js {}
      else
        @tiers = current_district.tiers
        format.html { render action: "edit" }
        format.js { render action: "edit" }
      end
    end
  end


  def undo
    @principal_override = current_user.principal_override_responses.find(params[:id])
    @principal_override.undo!
    respond_to do |format|
      format.html {redirect_to principal_overrides_url}
      format.js {}
    end

  end

  # DELETE /principal_overrides/1
  def destroy
    @principal_override = current_user.principal_override_requests.find(params[:id])
    @principal_override.destroy

    respond_to do |format|
      format.html { redirect_to(principal_overrides_url) }
      format.js   {}
    end
  end
end
