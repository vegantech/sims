class InterventionBuilder::ProbesController < ApplicationController
  skip_before_filter :authorize, :only => [:add_benchmark]
  additional_read_actions :add_benchmark

  def index
    @probe_definitions_in_groups =
      current_district.probe_definitions.group_by_cluster_and_objective
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
       flash[:notice]= 'Probe Definition was successfully created'
       redirect_to intervention_builder_probe_url(@probe_definition)
     else
       render :action=>"new"
     end
  end

  def update
    #TODO Move this to the model
    @probe_definition = current_district.probe_definitions.find(params[:id])

     if @probe_definition.update_attributes(params[:probe_definition])
       flash[:notice]= 'Probe Definition was successfully updated'
       redirect_to intervention_builder_probe_url(@probe_definition)
     else
       render :action=>"edit"
     end




  end

  def disable
    #disable/reenable
    probe_definition=current_district.find_probe_definition((params[:id]))
    if probe_definition
      probe_definition.toggle!(:active)
    else
      flash[:notice] = 'Probe Definition no longer exists.'
    end
    redirect_to intervention_builder_probes_url
  end

  def destroy
    probe_definition=current_district.find_probe_definition((params[:id]))
    if probe_definition && probe_definition.probes.count > 0
      flash[:notice]='Probe Definition could not be deleted, it is in use.'
    else
      probe_definition.destroy if probe_definition
    end
    redirect_to intervention_builder_probes_url

  end

  def add_benchmark
    @probe_definition_benchmark = ProbeDefinitionBenchmark.new
  end

end
