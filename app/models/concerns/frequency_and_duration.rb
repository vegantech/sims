module FrequencyAndDuration
  extend ActiveSupport::Concern
  include FrequencyConcern
  include DurationConcern

  def frequency_duration_summary
    "#{time_length_summary} / #{frequency_summary}"
  end

end
