module FrequencyAndDurationWithDates
  extend ActiveSupport::Concern
  include FrequencyAndDuration

  included do
    validates_presence_of :start_date, :end_date
    validate :end_date_after_start_date?
  end

  def end_date_after_start_date?
    if (end_date.blank? || start_date.blank? || end_date < start_date)
      errors.add(:end_date, "Must be after start date") and return false
    end
    true
  end

  def default_end_date
    if time_length_number and time_length
      (start_date + (time_length_number*time_length.days).days)
    else
      start_date
    end
  end

  def setup_default_dates
    if new_record?
      self.start_date ||= Date.today
      self.end_date ||= default_end_date
    end
  end
end
