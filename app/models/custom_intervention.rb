class CustomIntervention < Intervention
  attr_accessor :category
  accepts_nested_attributes_for :intervention_definition, :reject_if =>proc{|e| false}

  def self.model_name
    Intervention.model_name
  end

  def to_partial_path
    "/interventions/intervention"
  end

  def set_defaults_from_definition
    return unless new_record?
    build_intervention_definition :intervention_cluster => category if intervention_definition.blank?
    intervention_definition.set_values_from_intervention(self)
    set_defaults
    self.frequency ||= Frequency.find_by_title('Weekly')
    self.frequency_multiplier ||= 2
    self.time_length_number ||= 4
    self.time_length ||= TimeLength.find_by_title('Week')
  end

  def blank?
    category.blank?
  end

end
