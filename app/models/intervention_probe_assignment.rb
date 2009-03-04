# == Schema Information
# Schema version: 20090212222347
#
# Table name: intervention_probe_assignments
#
#  id                   :integer         not null, primary key
#  intervention_id      :integer
#  probe_definition_id  :integer
#  frequency_multiplier :integer
#  frequency_id         :integer
#  first_date           :datetime
#  end_date             :datetime
#  enabled              :boolean
#  created_at           :datetime
#  updated_at           :datetime
#

class InterventionProbeAssignment < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  belongs_to :intervention
  belongs_to :probe_definition
  belongs_to :frequency
  has_many :probes, :dependent => :destroy

  delegate :title, :to => :probe_definition
  delegate :student, :to => :intervention


  RECOMMENDED_FREQUENCY=2

#  validates_date :first_date, :end_date

#  validate :last_date_must_be_after_first_date

  named_scope :active, :conditions => {:enabled=>true}


  def self.disable(ipas)
    Array(ipas).each(&:disable)
  end

  def disable
    update_attributes(:enabled=>false)
  end

  def student_grade
    #TODO delegate this
    student.enrollments.first.grade
  end

  def frequency_summary
    "#{pluralize frequency_multiplier, "time"} #{frequency.title}"
  end

  protected
  def last_date_must_be_after_first_date
    errors.add(:end_date, "Last date must be after first date")     if self.first_date.blank? || self.end_date.blank? || self.end_date < self.first_date
  end

  def after_initialize
    self.frequency_multiplier=RECOMMENDED_FREQUENCY if self.frequency_multiplier.blank?
  end

end
