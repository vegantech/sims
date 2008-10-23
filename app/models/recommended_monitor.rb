class RecommendedMonitor < ActiveRecord::Base
  belongs_to :intervention_definition
  belongs_to :probe_definition

  acts_as_list :scope=>:intervention_definition_id
end
