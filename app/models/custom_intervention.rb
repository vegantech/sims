class CustomIntervention < Intervention
  accepts_nested_attributes_for :intervention_definition, reject_if: proc{|e| false}

  def self.model_name
    Intervention.model_name
  end

  def set_defaults_from_definition
    return unless new_record?
    intervention_definition.set_values_from_intervention(self)
    set_defaults
    self.frequency ||= Frequency.find_by_title('Weekly')
    self.frequency_multiplier ||= 2
    self.time_length_number ||= 4
    self.time_length ||= TimeLength.find_by_title('Week')
  end
end
