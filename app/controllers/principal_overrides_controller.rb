class PrincipalOverridesController < ApplicationController
  additional_write_actions :undo

  # GET /principal_overrides
  def index
    @principal_overrides = current_user.grouped_principal_overrides

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /principal_overrides/new
  def new
    @principal_override = current_user.principal_override_requests.build(:student=>current_student)

    respond_to do |format|
      format.js  { }
      format.html # new.html.erb
    end
  end

  # GET /principal_overrides/1/edit
  # Principal response
  def edit
    @principal_override = PrincipalOverride.find(params[:id])
    @principal_override.setup_response_for_edit(params[:response])
  end

  # POST /principal_overrides
  def create
    @principal_override = current_user.principal_override_requests.build(params[:principal_override].merge(:student=>current_student))

    respond_to do |format|
      if @principal_override.save
        flash[:notice] = 'PrincipalOverride was successfully created and sent'
        format.js   {}
        format.html { redirect_to(current_student) }
      else
        format.js   { render :action => "new" }
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /principal_overrides/1
  def update
    @principal_override = PrincipalOverride.find(params[:id])


    respond_to do |format|
      if @principal_override.update_attributes(params[:principal_override].merge(:principal_id=>current_user_id))
        flash[:notice] = 'PrincipalOverride was successfully updated.'
        format.js {}
        format.html { redirect_to(principal_overrides_url) }
      else
        format.js { render :action => "edit" }
        format.html { render :action => "edit" }
      end
    end
  end

  
  def undo
    @principal_override=current_user.principal_override_responses.find(params[:id])
    @principal_override.undo!
    respond_to do |format|
      format.js {}
      format.html {redirect_to principal_overrides_url}
    end

  end

  # DELETE /principal_overrides/1
  def destroy
    @principal_override = current_user.principal_override_requests.find(params[:id])
    @principal_override.destroy

    respond_to do |format|
      format.js   {}
      format.html { redirect_to(principal_overrides_url) }
    end
  end
end
