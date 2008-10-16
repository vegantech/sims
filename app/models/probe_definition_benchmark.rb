class ProbeDefinitionBenchmark < ActiveRecord::Base
  belongs_to :probe_definition
  validates_presence_of :benchmark, :grade_level
  validates_numericality_of :grade_level, :benchmark

  def validate
    if self.probe_definition.minimum_score && benchmark < self.probe_definition.minimum_score
      errors.add(:benchmark, "must be greater than the minimum score. for the probe definition")
    end
    
    if self.probe_definition.maximum_score && benchmark > self.probe_definition.maximum_score
      errors.add(:benchmark, "must be less than the maximum score. for the probe definition")
    end

  end

end
