# == Schema Information
# Schema version: 20090118224504
#
# Table name: probe_definition_benchmarks
#
#  id                  :integer         not null, primary key
#  probe_definition_id :integer
#  benchmark           :integer
#  grade_level         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class ProbeDefinitionBenchmark < ActiveRecord::Base
  belongs_to :probe_definition
  validates_presence_of :benchmark, :grade_level
  validates_numericality_of :benchmark
  validate :validate_within_probe_definition_range





  protected
  def validate_within_probe_definition_range
    
    if probe_definition
      if self.probe_definition.minimum_score && benchmark < self.probe_definition.minimum_score
        errors.add(:benchmark, "must be greater than the minimum score. for the probe definition")
      end
      
      if self.probe_definition.maximum_score && benchmark > self.probe_definition.maximum_score
        errors.add(:benchmark, "must be less than the maximum score. for the probe definition")
      end
  end

  end

end
