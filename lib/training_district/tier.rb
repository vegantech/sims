module TrainingDistrict::Tier
  def generate_tiers
    if File.exist?(File.join(path,"tiers.csv"))
      generate_tiers_from_file
    else
      generate_tiers_without_file
    end
  end

  def generate_tiers_from_file
    tier_csv=CSV.table("#{path}/tiers.csv").sort_by{|e| e[:position]}
    @oldtiers=tier_csv.collect{|t| t[:id]}
    @tiers=[]
    tier_csv.each do |ck|
      ckhash = prephash(ck)
      @tiers <<  district.tiers.create!(ckhash)
    end
  end

  def generate_tiers_without_file
    @oldtiers=[781074649, 781074650, 781074651]
    @tier = district.tiers.create!(title: 'First tier')
    second_tier = district.tiers.create!(title: 'Second tier')
    third_tier = district.tiers.create!(title: 'Third tier')
    @tiers = [@tier,second_tier,third_tier]
  end

  def map_tier_id(ck)
    tiers[oldtiers.index(ck[:tier_id].to_i)].try(:id) || @tier
  end
end
