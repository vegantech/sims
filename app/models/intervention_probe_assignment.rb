# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_probe_assignments
#
#  id                   :integer(4)      not null, primary key
#  intervention_id      :integer(4)
#  probe_definition_id  :integer(4)
#  frequency_multiplier :integer(4)
#  frequency_id         :integer(4)
#  first_date           :date
#  end_date             :date
#  enabled              :boolean(1)
#  created_at           :datetime
#  updated_at           :datetime
#  goal                 :integer(4)
#

class InterventionProbeAssignment < ActiveRecord::Base
  DISTRICT_PARENT = :intervention
  include ActionView::Helpers::TextHelper
  belongs_to :intervention
  belongs_to :probe_definition
  belongs_to :frequency
  has_many :probes, dependent: :destroy

  delegate :title, to: :probe_definition
  delegate :student, to: :intervention
  validates_associated :probes # ,:probe_definition
  validate :last_date_must_be_after_first_date
  validate :goal_in_range

  after_initialize :set_default_frequency_multiplier

  accepts_nested_attributes_for :probe_definition

  RECOMMENDED_FREQUENCY = 2

#  validates_date :first_date, :end_date

  scope :active, where(enabled: true)

  def self.disable(ipas)
    Array(ipas).each(&:disable)
  end

  def disable
    update_attributes(enabled: false)
  end

  def student_grade
    # TODO delegate this
    student.enrollments.first.grade
  end

  def frequency_summary
    "#{pluralize frequency_multiplier, "time"} #{frequency}"
  end

  def valid_score_range
    "#{probe_definition.minimum_score} - #{probe_definition.maximum_score}"
  end

  def new_probes=(params)
    params=params.values
    params.each do |param|
      @new_probe = probes.build(param) unless param['score'].blank?
    end
  end

  def to_param
    unless new_record?
      id.to_s
    else
      "pd#{probe_definition_id}"
    end
  end

  def graph(graph_type=nil)
    ProbeGraph::Base.build(graph_type: graph_type,
                           probes: probes.to_a,
                           probe_definition: probe_definition,
                           district: student.district,
                           first_date: first_date,
                           end_date: end_date,
                           goal: goal)
  end

  protected
  def last_date_must_be_after_first_date
    errors.add(:end_date, "Last date must be after first date")     if self.first_date.blank? || self.end_date.blank? || self.end_date < self.first_date
  end

  def set_default_frequency_multiplier
    self.frequency_multiplier=RECOMMENDED_FREQUENCY if self[:frequency_multiplier].blank?
  end

  def goal_in_range
    if goal.present? and self.probe_definition.present?
      if probe_definition.minimum_score.present? and goal < probe_definition.minimum_score
        errors.add(:goal, "below minimum") and return false
      end

      if probe_definition.maximum_score.present? and goal > probe_definition.maximum_score
        errors.add(:goal, "above maximum") and return false
      end

    end
  end
end
