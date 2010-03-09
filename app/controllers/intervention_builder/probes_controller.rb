class InterventionBuilder::ProbesController < ApplicationController
  include SpellCheck
  skip_before_filter :authorize, :only => [:add_benchmark, :suggestions]
  additional_read_actions :add_benchmark

  def index
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
    spellcheck [@probe_definition.title,@probe_definition.description].join(" ") and render :action=>:new and return unless params[:spellcheck].blank?

     if @probe_definition.save
       flash[:notice]= 'Progress Monitor Definition was successfully created'
       redirect_to intervention_builder_probe_url(@probe_definition)
     else
       render :action=>"new"
     end
  end

  def update
    @probe_definition = current_district.probe_definitions.find(params[:id])
    @probe_definition.attributes = params[:probe_definition]
    spellcheck [@probe_definition.title,@probe_definition.description].join(" ") and render :action=>:edit and return unless params[:spellcheck].blank?

     if @probe_definition.save
       flash[:notice]= 'Progress Monitor Definition was successfully updated'
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

  def add_benchmark
    @probe_definition_benchmark = ProbeDefinitionBenchmark.new
  end

end
