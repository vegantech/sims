# == Schema Information
# Schema version: 20081227220234
#
# Table name: intervention_definitions
#
#  id                      :integer         not null, primary key
#  title                   :string(255)
#  description             :text
#  custom                  :boolean
#  intervention_cluster_id :integer
#  tier_id                 :integer
#  time_length_id          :integer
#  time_length_num         :integer         default(1)
#  frequency_id            :integer
#  frequency_multiplier    :integer         default(1)
#  user_id                 :integer
#  school_id               :integer
#  disabled                :boolean
#  position                :integer
#  rec_mon_preface         :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

class InterventionDefinition < ActiveRecord::Base
  belongs_to :intervention_cluster
  belongs_to :frequency
  belongs_to :time_length
  belongs_to :tier
  belongs_to :user
  belongs_to :school
  has_many :recommended_monitors, :order => :position
  has_many :probe_definitions, :through => :recommended_monitors
  has_many :quicklist_items, :dependent=>:destroy
  
  validates_presence_of :title, :description, :time_length_id, :time_length_num, :frequency_id, :frequency_multiplier
  validates_numericality_of :frequency_multiplier, :time_length_num

  acts_as_list :scope=>'intervention_cluster_id'

  def interventions
    []
  end

  def business_key
    "#{tier_id}-#{goal_definition.position}-#{objective_definition.position}    -#{intervention_cluster.position}-#{position}"
  end

  def district
    goal_definition.district
  end

  def district_quicklist
    !!quicklist_items.find_by_district_id(district.id)
  end

  def district_quicklist=(arg)
    if arg =="1"
      quicklist_items.build(:district_id=>self.district.id) unless district_quicklist
    else
      g=quicklist_items.find_by_district_id(self.district.id) 
      g.destroy if district_quicklist
    end
  end

  def goal_definition
    objective_definition.goal_definition
  end
  
  def objective_definition
    intervention_cluster.objective_definition
  end


  def disable!
    update_attribute(:disabled,true)
  end

  def ancestor_ids
    [objective_definition.goal_definition_id,objective_definition.id,intervention_cluster_id,id]
  end

end


