class Tier < ActiveRecord::Base
  TIERS=Tier.find(:all,:order=>"position")
end
