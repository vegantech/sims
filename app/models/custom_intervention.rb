class CustomIntervention < Intervention
  accepts_nested_attributes_for :intervention_definition, :reject_if =>proc{|e| false}

  def self.model_name
    Intervention.model_name
  end

  def self.build_and_initialize(args)
    super(args).tap{ |int|
      int.intervention_definition.set_values_from_intervention(int)
    }
  end

  def set_defaults_from_definition
    return unless new_record?
    self.start_date ||= Date.today
    self.frequency ||= Frequency.find_by_title('Weekly')
    self.frequency_multiplier ||= 2
    self.time_length_number ||= 4
    self.time_length ||= TimeLength.find_by_title('Week')
    self.end_date ||= default_end_date
  end
end
