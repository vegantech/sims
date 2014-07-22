class InterventionBuilder::ProbesController < InterventionBuilder::BaseController
  skip_before_filter :verify_authenticity_token, only: :disable

  def index
    params[:enabled]=true and params[:commit]=true unless params[:commit]
    @probe_definitions_in_groups =
      current_district.probe_definitions.group_by_cluster_and_objective(params)
  end

  def show
    @probe_definition=current_district.probe_definitions.find(params[:id])
  end

  def new
    @probe_definition = current_district.probe_definitions.build
  end

  def edit
    @probe_definition = current_district.probe_definitions.find(params[:id])
  end

  def create
    @probe_definition = current_district.probe_definitions.build(params[:probe_definition])

    if @probe_definition.save
      flash[:notice]= 'Progress Monitor Definition was successfully created'
      redirect_to intervention_builder_probe_url(@probe_definition)
    else
      render action: "new"
    end
  end

  def update
    @probe_definition = current_district.probe_definitions.find(params[:id])
    @probe_definition.attributes = params[:probe_definition]

    if @probe_definition.save
      flash[:notice]= 'Progress Monitor Definition was successfully updated'
      redirect_to intervention_builder_probe_url(@probe_definition)
    else
      render action: "edit"
    end
  end

  def disable
    if params[:commit]
      pds=current_district.probe_definitions.find_all_by_id(params[:id])
      pds.each{|i| i.update_attribute(:active,false)}
      flash[:notice] = "#{view_context.pluralize(pds.size, 'Progress Monitor')} disabled."
      redirect_to intervention_builder_probes_url and return
    end

    #disable/reenable
    probe_definition=current_district.find_probe_definition((params[:id]))
    if probe_definition
      probe_definition.toggle!(:active)
    else
      flash[:notice] = 'Progress Monitor Definition no longer exists.'
    end
    redirect_to intervention_builder_probes_url
  end

  def destroy
    probe_definition=current_district.find_probe_definition((params[:id]))
    if probe_definition && probe_definition.probes.count > 0
      flash[:notice]='Progress Monitor Definition could not be deleted, it is in use.'
    else
      probe_definition.destroy if probe_definition
    end
    redirect_to intervention_builder_probes_url
  end
end
