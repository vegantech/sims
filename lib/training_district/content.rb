class TrainingDistrict::Content
  attr_reader :district,:path,:tiers,:oldtiers,:probe_hash,:definitionhash, :checklisthash
  include TrainingDistrict::Tier, TrainingDistrict::Intervention
  def initialize(district,path = "db/training")
    @district = district
    @path = path
    @probe_hash = {}
    @definitionhash = {}
    @checklisthash = {}
  end

  def prephash(ck)
    return nil if ck.to_hash[:deleted_at].to_i != 0
    ckhash = ck.to_hash.delete_if{|k,v| v == 0}
    ckhash[:disabled] = false if ckhash[:disabled].nil? and ckhash.keys.include?:disabled
    ckhash.except(:deleted_at,:copied_at,:copied_from,:id,:district_id, :notify_email)
  end

  def populate_from_csv_file(parent,model_name,parent_id_sym, parenthash = {})
    Hash.new.tap do |reshash|
      CSV.table("#{path}/#{model_name.pluralize}.csv").each do |ck|
        next unless ckhash = prephash(ck)
        ckhash[parent_id_sym] = parenthash[ck[parent_id_sym]] unless parenthash.empty?
        reshash[ck[:id]] = parent.create!(ckhash).id
      end
    end
  end

  def generate_assets
    CSV.table("#{path}/assets.csv").each do |ck|
      old_id = ck[:attachable_id]
      case ck[:attachable_type]
      when 'ProbeDefinition'
        newid = probe_hash[old_id]
      when 'InterventionDefinition'
        newid = definitionhash[old_id]
      else
        newid = nil
      end
      generate_assets_from_row(newid, ck) if newid.present?
    end
  end

  def generate_assets_from_row(attachable_id, row)
    generate_asset_from_name_and_url(attachable_id, row) if row[:url].present? && row[:url].to_s != "0"
    generate_asset_from_file(attachable_id,row) if row[:document_file_name].present? && row[:document_file_name].to_s != "0"
  end

  def generate_asset_from_name_and_url(attachable_id, row)
    if row[:url].to_s.include?("/")
      url = row[:url]
    else
      url = "/file/#{row[:url]}"
    end

    raise row.inspect if url == "/file/0"
    Asset.create!(attachable_type: row[:attachable_type], attachable_id: attachable_id, url: url, name: row[:name])
  end

  def generate_asset_from_file(attachable_id, row)
    filename = row[:document_file_name]
    Asset.create!(attachable_type: row[:attachable_type], attachable_id: attachable_id, url: "/file/#{filename}", name: filename)
  end

  def generate_checklist_definitions
    CSV.table("#{path}/checklist_definitions.csv").each do |ck|
      next unless ckhash = prephash(ck)
      ckhash[:active] = active_checklist_district
      @checklisthash[ck[:id]] = district.checklist_definitions.create!(ckhash).id
    end
  end

  def active_checklist_district
    !!district.abbrev.match(/^training/) || district.abbrev == 'madison'
  end

  def generate_answer_definitions elementhash
    CSV.table("#{path}/answer_definitions.csv").each do |ck|
      next unless ckhash = prephash(ck)
      ckhash[:value] ||= 0
      ckhash[:element_definition_id] = elementhash[ck[:element_definition_id]]
      newcd = AnswerDefinition.create!(ckhash)
    end
  end

  def generate_checklist_definition
    generate_checklist_definitions
    questionhash = populate_from_csv_file(QuestionDefinition,"question_definition",:checklist_definition_id,checklisthash)
    elementhash = populate_from_csv_file(ElementDefinition,"element_definition",:question_definition_id,questionhash)
    generate_answer_definitions elementhash
  end
end
