module Duration
  include ActionView::Helpers::TextHelper #for pluralize
  extend ActiveSupport::Concern

  included do
    belongs_to :time_length
    validates_numericality_of :time_length_number
    validates_presence_of :start_date, :end_date
    validate :end_date_after_start_date?
    after_initialize :setup_default_duration
  end

  def time_length_summary
    pluralize time_length_number, time_length.title
  end

  protected

  def end_date_after_start_date?
    if (end_date.blank? || start_date.blank? || end_date < start_date)
      errors.add(:end_date, "Must be after start date") and return false
    end
    true
  end

  def default_end_date
   if time_length_number and time_length
      (start_date + (time_length_number * time_length.days).days)
   else
      start_date
   end
  end

  def setup_default_duration
    if new_record?
      self.start_date ||= Date.today
      self.end_date ||= default_end_date
    end
  end
end
