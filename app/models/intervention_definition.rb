# == Schema Information
# Schema version: 20081208201532
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
  
  validates_presence_of :title, :description, :time_length_id, :time_length_num, :frequency_id, :frequency_multiplier
  validates_numericality_of :frequency_multiplier, :time_length_num

  acts_as_list :scope=>'intervention_cluster_id'

  def interventions
    []
  end

  def business_key
    "#{tier_id}-#{goal_definition.position}-#{objective_definition.position}    -#{intervention_cluster.position}-#{position}"
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

  # TODO: Where does this really want to live?  Look into factory girl or object daddy
  def self.make!(opts={})
    opts.reverse_merge!(:title=>"Title", :description =>"Description", :time_length_id=>1, :time_length_num=>1, :frequency_id =>1, :frequency_multiplier =>1)
    self.create!(opts)
  end
end


