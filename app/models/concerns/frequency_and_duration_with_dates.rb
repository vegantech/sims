module FrequencyAndDurationWithDates
  extend ActiveSupport::Concern
  include FrequencyAndDuration
=begin
  included do
    belongs_to :frequency
    validates_presence_of :frequency_id, :frequency_multiplier
    validates_numericality_of :frequency_multiplier
  end

  def frequency_summary
    "#{pluralize frequency_multiplier, "time"} #{frequency.title}"
  end

=end
end
