class InterventionBuilder::ProbesController < ApplicationController

  def index
    @probe_definitions_in_groups =
      current_district.probe_definitions.group_by_cluster_and_objective
  end

  def show
    @probe_definition=current_district.probe_definitions.find(params[:id])

  end

  def new
    @probe_definition = current_district.probe_definitions.build
    @probe_definition.assets.build
  end

  def edit
    @probe_definition=current_district.probe_definitions.find(params[:id])
  end

  def create
    @probe_definition = current_district.probe_definitions.build(params[:probe_definition])
    #TODO Move this to the model

     if params[:probe_definition_benchmarks]
       params[:probe_definition_benchmarks].each_value do | benchmark |
         @probe_definition.probe_definition_benchmarks.build(benchmark.merge(
                            :probe_definition=>@probe_definition)) unless benchmark.values.all?(&:blank?)
       end
     end

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
    bench=@probe_definition.probe_definition_benchmark_ids
     if params[:probe_definition_benchmarks]
       params[:probe_definition_benchmarks].each_value do | benchmark |
         @probe_definition.probe_definition_benchmarks.build(benchmark.merge(
                            :probe_definition=>@probe_definition)) unless benchmark.values.all?(&:blank?)
       end
     end


     if @probe_definition.update_attributes(params[:probe_definition])
       flash[:notice]= 'Probe Definition was successfully updated'
       @probe_definition.probe_definition_benchmarks.destroy(bench)
       redirect_to intervention_builder_probe_url(@probe_definition)
     else
       render :action=>"edit"
     end




  end

  def disable
    #disable/reenable
    probe_definition=current_district.probe_definitions.find(params[:id])
    probe_definition.toggle!(:active)
    redirect_to intervention_builder_probes_url
  end

  def destroy
    probe_definition=current_district.probe_definitions.find(params[:id])
    if probe_definition.probes.count > 0
      flash[:notice]='Probe Definition could not be deleted, it is in use.'
    else
      probe_definition.destroy
    end
    redirect_to intervention_builder_probes_url

  end
 
end
