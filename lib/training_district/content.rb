class TrainingDistrict::Content
  attr_reader :district,:path,:tiers,:oldtiers,:probe_hash,:definitionhash
  def initialize(district,path="db/training")
    @district = district
    @path = path
    @probe_hash={}
    @definitionhash = {}
  end

  def populate_from_csv_file(parent,model_name,parent_id_sym, parenthash ={})
    reshash={}
    CSV.table("#{path}/#{model_name.pluralize}.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:disabled] = false if ckhash[:disabled].nil? and parent.column_names.include?"disabled"
      ckhash[parent_id_sym]= parenthash[ck[parent_id_sym]] unless parenthash.empty?
      newcd= parent.create!(ckhash.except(:deleted_at,:copied_at,:copied_from,:id,:district_id))
      reshash[ck[:id]]=newcd.id
    end
    reshash
  end

  def generate_tiers
    if File.exist?(File.join(path,"tiers.csv"))
      tier_csv=CSV.table("#{path}/tiers.csv").sort_by{|e| e[:position]}
      @oldtiers=tier_csv.collect{|t| t[:id]}
      @tiers=[]
      tier_csv.each do |ck|
        ckhash = ck.to_hash.delete_if{|k,v| v == 0}
        @tiers <<  district.tiers.create!(ckhash.except(:deleted_at,:copied_at,:copied_from))
      end
    else
      @oldtiers=[781074649, 781074650, 781074651]
      tier = district.tiers.create!(:title=>'First tier')
      second_tier = district.tiers.create!(:title=>'Second tier')
      third_tier = district.tiers.create!(:title=>'Third tier')
      @tiers = [tier,second_tier,third_tier]
    end
  end

  def generate_intervention_definitions(clusterhash)
    CSV.table("#{path}/intervention_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:intervention_cluster_id]= clusterhash[ck[:intervention_cluster_id]]
      mytier = tiers.collect(&:id)[oldtiers.index(ck[:tier_id].to_i)] || tier
      ckhash[:disabled] = false if ckhash[:disabled].nil?
      unless ckhash[:disabled] or ckhash[:custom]
        ckhash[:notify_email] = nil
        newcd= InterventionDefinition.create!(ckhash.merge(:tier_id => mytier).except(:deleted_at,:copied_at,:copied_from))
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
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      if ckhash[:active] and !ckhash[:custom]
        newcd= district.probe_definitions.create!(ckhash.except(:deleted_at,:copied_at,:copied_from,:id,:district_id))
        @probe_hash[ck[:id]]=newcd.id
      end
    end
  end


  def generate_recommended_monitors
    CSV.table("#{path}/recommended_monitors.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:intervention_definition_id]= definitionhash[ck[:intervention_definition_id]]
      ckhash[:probe_definition_id]= probe_hash[ck[:probe_definition_id]]
      newcd= RecommendedMonitor.new(ckhash.except(:deleted_at,:copied_at,:copied_from))
      newcd.save! if newcd.probe_definition && newcd.intervention_definition
    end
  end

  def generate_probe_definition_benchmarks
    CSV.table("#{path}/probe_definition_benchmarks.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:probe_definition_id]= probe_hash[ck[:probe_definition_id]]
      newcd= ProbeDefinitionBenchmark.new(ckhash.except(:deleted_at,:copied_at,:copied_from))
      newcd.save! if newcd.valid?
    end
  end

  def generate_assets
    CSV.table("#{path}/assets.csv").each do |ck|
      old_id = ck[:attachable_id]
      case ck[:attachable_type]
      when 'ProbeDefinition'
        newid=probe_hash[old_id]
      when 'InterventionDefinition'
        newid = definitionhash[old_id]
      else
        newid = nil
      end
      generate_assets_from_row(newid, ck) if newid.present?
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

  def generate_assets_from_row(attachable_id, row)
    generate_asset_from_name_and_url(attachable_id, row) if row[:url].present? && row[:url].to_s !="0"
    generate_asset_from_file(attachable_id,row) if row[:document_file_name].present? && row[:document_file_name].to_s != "0"
  end

  def generate_asset_from_name_and_url(attachable_id, row)
    if row[:url].to_s.include?("/")
      url = row[:url]
    else
      url = "/file/#{row[:url]}"
    end

    raise row.inspect if url == "/file/0"
    Asset.create!(:attachable_type => row[:attachable_type], :attachable_id => attachable_id, :url => url, :name => row[:name])
  end

  def generate_asset_from_file(attachable_id, row)
    filename = row[:document_file_name]
    Asset.create!(:attachable_type => row[:attachable_type], :attachable_id => attachable_id, :url => "/file/#{filename}", :name => filename)
  end

  def generate_checklist_definitions
    checklisthash = {}
    CSV.table("#{path}/checklist_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:active]=!!district.abbrev.match(/^training/) || district.abbrev =='madison'

      newcd= district.checklist_definitions.create!(ckhash.except(:deleted_at,:copied_at,:copied_from,:district_id,:id))
      checklisthash[ck[:id]]=newcd.id
    end
    checklisthash
  end

  def generate_answer_definitions elementhash
    CSV.table("#{path}/answer_definitions.csv").each do |ck|
     next if ck.to_hash[:deleted_at].to_i !=0
     ckhash = ck.to_hash.delete_if{|k,v| v == 0}
     ckhash[:value] ||=0
     ckhash[:element_definition_id]= elementhash[ck[:element_definition_id]]
     newcd= AnswerDefinition.create!(ckhash.except(:deleted_at,:copied_at,:copied_from))
   end
  end

  def generate_checklist_definition
    questionhash = {}
    elementhash = {}
    checklisthash=generate_checklist_definitions
    questionhash=populate_from_csv_file(QuestionDefinition,"question_definition",:checklist_definition_id,checklisthash)
    elementhashash=populate_from_csv_file(ElementDefinition,"element_definition",:question_definition_id,questionhash)
    generate_answer_definitions elementhash
  end
end
