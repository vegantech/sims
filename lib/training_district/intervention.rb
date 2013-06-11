module TrainingDistrict::Intervention
  def generate_intervention_definitions(clusterhash)
    CSV.table("#{path}/intervention_definitions.csv").each do |ck|
      next unless ckhash = prephash(ck)
      ckhash[:intervention_cluster_id]= clusterhash[ck[:intervention_cluster_id]]
      unless ckhash[:disabled] or ckhash[:custom]
        ckhash[:notify_email] = nil
        newcd= InterventionDefinition.create!(ckhash.merge(:tier_id => map_tier_id(ck)))
        @definitionhash[ck[:id]]=newcd.id
      end
    end
  end

  def generate_probe_definitions
    if File.exist?("#{path}/probe_definitions_monitors.csv")
      pdf="#{path}/probe_definitions_monitors.csv"
    else
      pdf = "#{path}/probe_definitions.csv"
    end

    CSV.table(pdf).each do |ck|
      next unless ckhash = prephash(ck)
      if ckhash[:active] and !ckhash[:custom]
        newcd= district.probe_definitions.create!(ckhash)
        @probe_hash[ck[:id]]=newcd.id
      end
    end
  end

  def generate_interventions
    generate_tiers
    goalhash=populate_from_csv_file(district.goal_definitions,"goal_definition",nil)
    objectivehash=populate_from_csv_file(ObjectiveDefinition,"objective_definition",:goal_definition_id,goalhash)
    clusterhash=populate_from_csv_file(InterventionCluster,"intervention_cluster", :objective_definition_id,objectivehash)
    generate_intervention_definitions clusterhash
    generate_probe_definitions
    generate_recommended_monitors
    generate_probe_definition_benchmarks
    generate_assets
  end

  def generate_recommended_monitors
    CSV.table("#{path}/recommended_monitors.csv").each do |ck|
      next unless ckhash = prephash(ck)
      ckhash[:intervention_definition_id]= definitionhash[ck[:intervention_definition_id]]
      ckhash[:probe_definition_id]= probe_hash[ck[:probe_definition_id]]
      newcd= RecommendedMonitor.new(ckhash.except(:deleted_at,:copied_at,:copied_from))
      newcd.save! if newcd.probe_definition && newcd.intervention_definition
    end
  end

  def generate_probe_definition_benchmarks
    CSV.table("#{path}/probe_definition_benchmarks.csv").each do |ck|
      next unless ckhash = prephash(ck)
      ckhash[:probe_definition_id]= probe_hash[ck[:probe_definition_id]]
      newcd= ProbeDefinitionBenchmark.new(ckhash.except(:deleted_at,:copied_at,:copied_from))
      newcd.save! if newcd.valid?
    end
  end
end
