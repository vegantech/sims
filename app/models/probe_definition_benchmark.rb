# == Schema Information
# Schema version: 20090325230037
#
# Table name: probe_definition_benchmarks
#
#  id                  :integer         not null, primary key
#  probe_definition_id :integer
#  benchmark           :integer
#  grade_level         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  copied_at           :datetime
#  copied_from         :integer
#

class ProbeDefinitionBenchmark < ActiveRecord::Base
  GRADE_LEVEL_SIZE=4
  belongs_to :probe_definition
  validates_presence_of :benchmark, :grade_level
  validates_length_of :grade_level ,:maximum=>GRADE_LEVEL_SIZE
  validates_numericality_of :benchmark
  validate :validate_within_probe_definition_range
  is_paranoid

  def deep_clone(pd)
    k=pd.probe_definition_benchmarks.find_with_destroyed(:first,:conditions=>{:copied_from=>self.id}) 
    if k
      #it already exists
   else
      k=clone
      k.probe_definition =pd
      k.copied_at=Time.now
      k.copied_from = id
      k.save! if k.valid?
    end
    k
  end


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
