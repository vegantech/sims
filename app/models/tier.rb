# == Schema Information
# Schema version: 20090428193630
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
  has_many :checklists, :foreign_key=>:from_tier
  has_many :recommendations
  has_many :intervention_definitions
  has_many :principal_override_requests, :class_name=>'PrincipalOverride', :foreign_key=>:start_tier_id
  has_many :principal_override_acceptances, :class_name=>'PrincipalOverride', :foreign_key=>:end_tier_id

  acts_as_list :scope => :district
  validates_presence_of :title

  def to_s
    "#{position} - #{title}"
  end

  def <=>(b)
    position <=> b.position
  end

  def used_by
    result = self.checklists | self.recommendations | 
              self.intervention_definitions | self.principal_override_requests |
              self.principal_override_acceptances
    result = nil if result.empty?
    result
  end
    
end
