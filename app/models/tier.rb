class Tier
  def self.tiers
    [Tier.new] * 3
  end
  def title
    'Tier'
  end

  def self.find(*args)
    Tier.new
  end

end
