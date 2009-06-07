# == Schema Information
# Schema version: 20090524185436
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

  before_destroy :move_children_to_delete_successor, :if => :used_at_all? 
  acts_as_list :scope => :district
  validates_presence_of :title

  def to_s
    "#{position} - #{title}"
  end

  def <=>(b)
    position <=> b.position
  end

  def used_at_all?
    Tier.reflect_on_all_associations(:has_many).any? do |child_association|
      self.send(child_association.name).exists?
    end
  end

  def not_needed_anymore?
    result = self.checklists | self.recommendations | 
              self.intervention_definitions | self.principal_override_requests |
              self.principal_override_acceptances
    result = nil if result.empty?
    result
  end

  def delete_successor
    if last?
      higher_item
    else
      lower_item
    end
  end

  private

  def move_children_to_delete_successor
    successor_id = delete_successor.id
    #reflect on all associations
    #update all where options[:foreign_key] = self.id

    Tier.reflect_on_all_associations(:has_many).each do |child_association|
      for_key= child_association.options[:foreign_key] || 'tier_id'
      self.send(child_association.name).update_all(for_key => successor_id)
    end
  end
end
