class FlagDescriptionsController < ApplicationController
  # GET /flag_descriptions
  # GET /flag_descriptions.xml
  def index
    @flag_description = FlagDescription.find_or_initialize_by_district_id(current_district.id)
    render action: 'edit' and return

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def create
    update
  end

  # PUT /flag_descriptions/1
  # PUT /flag_descriptions/1.xml
  def update
    @flag_description = FlagDescription.find_or_initialize_by_district_id(current_district.id)

    respond_to do |format|
      if @flag_description.update_attributes(params[:flag_description])
        flash[:notice] = 'FlagDescription was successfully updated.'
        format.html { redirect_to(root_url) }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
