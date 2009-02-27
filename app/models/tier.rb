# == Schema Information
# Schema version: 20090212222347
#
# Table name: tiers
#
#  id          :integer         not null, primary key
#  district_id :integer
#  title       :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Tier < ActiveRecord::Base
  belongs_to :district
  begin
    TIERS=Tier.find(:all,:order=>"position")
  rescue
    puts "Table may not exist yet"
  end

  def to_s
    "#{position} - #{title}"
  end

  def after_create
    Tier.const_set("TIERS",Tier.all(:order=>"position"))
  end
end
