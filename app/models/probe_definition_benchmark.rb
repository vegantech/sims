# == Schema Information
# Schema version: 20101101011500
#
# Table name: probe_definition_benchmarks
#
#  id                  :integer(4)      not null, primary key
#  probe_definition_id :integer(4)
#  benchmark           :integer(4)
#  grade_level         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class ProbeDefinitionBenchmark < ActiveRecord::Base
  GRADE_LEVEL_SIZE=4
  belongs_to :probe_definition
  validates_presence_of :benchmark, :grade_level
  validates_length_of :grade_level ,:maximum=>GRADE_LEVEL_SIZE
  validates_numericality_of :benchmark
  validate :validate_within_probe_definition_range

  scope :content_export, order

  def to_s
    "Gr: #{grade_level}  - #{benchmark}"
  end

  def color
    #used on graphs
    if new_record?
      '00ff00'
    else
      'ff9c00'
    end
  end

  protected
  def validate_within_probe_definition_range

    if probe_definition && benchmark.present?
      if self.probe_definition.minimum_score && benchmark < self.probe_definition.minimum_score
        errors.add(:benchmark, "must be greater than the minimum score. for the progress monitor definition")
      end

      if self.probe_definition.maximum_score && benchmark > self.probe_definition.maximum_score
        errors.add(:benchmark, "must be less than the maximum score. for the progress monitor definition")
      end
  end

  end

end
