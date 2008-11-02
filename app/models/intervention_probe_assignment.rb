# == Schema Information
# Schema version: 20081030035908
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
  belongs_to :intervention
  belongs_to :probe_definition
  belongs_to :frequency
  has_many :probes

  RECOMMENDED_FREQUENCY=2

  validates_date :first_date, :end_date

  validate :last_date_must_be_after_first_date


  def self.disable(ipas)
    Array(ipas).each(&:disable)
  end

  def disable
    update_attributes(:disabled=>true)
  end


  protected
  def last_date_must_be_after_first_date
    errors.add(:end_date, "Last date must be after first date")     if self.first_date.blank? || self.end_date.blank? || self.end_date < self.first_date
  end

  def after_initialize
    self.frequency_multiplier=RECOMMENDED_FREQUENCY if self.frequency_multiplier.blank?
  end

end
