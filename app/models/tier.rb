class Tier < ActiveRecord::Base
  belongs_to :district
  TIERS=Tier.find(:all,:order=>"position")
end
