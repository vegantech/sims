module ValidatesDateTime
  module MultiparameterAttributes
    def read_date_parameter_value(name, values_hash_from_param)
      set_values = (1..3).map { |i| values_hash_from_param[i] }.compact
      extract_date_from_multiparameter_attributes(set_values)
    end

    def read_time_parameter_value(name, values_hash_from_param)
      is_datetime = column_for_attribute(name).type == :datetime

      if is_datetime
        set_values = (1..6).map { |i| values_hash_from_param[i] }
        date_values = set_values.slice!(0, 3)
        time_values = set_values

        extract_date_from_multiparameter_attributes(date_values) + " " + extract_time_from_multiparameter_attributes(time_values)
      else
        set_values = (1..3).map { |i| values_hash_from_param[i] }.compact
        extract_time_from_multiparameter_attributes(set_values)
      end
    end

    def extract_date_from_multiparameter_attributes(values)
      [values.shift, *values.map { |s| s.to_s.rjust(2, "0") }].join("-")
    end

    def extract_time_from_multiparameter_attributes(values)
      values.map { |s| s.to_s.rjust(2, "0") }.join(":")
    end
  end
end