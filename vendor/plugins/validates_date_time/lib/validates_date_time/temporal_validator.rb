module ValidatesDateTime
  class TemporalValidator < ActiveModel::EachValidator
    def initialize(options)
      options.assert_valid_keys :attributes, :message, :before_message, :after_message, :before, :after, :if, :on, :allow_blank, :_parse_method

      # We must remove this from the configuration that is passed to validates_each because
      # we want do not want to skip validation if the type cast value is blank.
      @allow_blank = options.delete(:allow_blank)

      options[:before] = prepare_restrictions(options[:before], options[:_parse_method])
      options[:after] = prepare_restrictions(options[:after], options[:_parse_method])

      super(options)
    end

    def validate_each(record, attribute, value)
      attribute = attribute.to_s

      raw_value = record.read_attribute_before_type_cast(attribute)
      column = record.class.columns_hash[attribute]

      # A value that is unable to be parsed, and a blank value where allow_blank is not set are both invalid
      if (raw_value.present? and !value.is_a?(column.klass)) or (raw_value.blank? and !@allow_blank)
        error_message = options[:message] || options[:_parse_method]

        record.errors.add(attribute, options[:_parse_method], options.merge(:message => error_message))
      elsif value
        validate_before_and_after_restrictions(record, attribute, value)
      end
    end

    private
      def validate_before_and_after_restrictions(record, attr_name, value)
        Array.wrap(@options[:before]).each do |r|
          if r.value(record) and value >= r.last_value
            error_message = options[:before_message] || :before

            record.errors.add(attr_name, :before, options.merge(:message => error_message, :value => r))
            break
          end
        end

        Array.wrap(@options[:after]).each do |r|
          if r.value(record) and value <= r.last_value
            error_message = options[:after_message] || :after

            record.errors.add(attr_name, :after, options.merge(:message => error_message, :value => r))
            break
          end
        end
      end

      def prepare_restrictions(restrictions, parse_method)
        Array.wrap(restrictions).map { |r| Restriction.new(r, parse_method) }
      end

    class Restriction < Struct.new(:raw_value, :parse_method)
      def value(record)
        @last_value = case raw_value
          when Symbol
            record.send(raw_value)
          when Proc
            raw_value.call(record)
          else
            raw_value
        end

        @last_value = parse(@last_value)
      end

      def parse(string)
        ActiveRecord::ConnectionAdapters::Column.send("string_to_#{parse_method}", string)
      end

      def last_value
        @last_value
      end

      def to_s
        if raw_value.is_a?(Symbol)
          raw_value.to_s.humanize
        else
          @last_value.to_s
        end
      end
    end
  end
end
