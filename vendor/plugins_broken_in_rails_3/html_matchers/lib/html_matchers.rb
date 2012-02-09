begin
require 'hpricot'
rescue LoadError
end

# %w(check_box_group drop_down radio_group span_text table_body table_header td_link).each do |element|
  # require File.join(File.dirname(__FILE__), 'matchers', "#{element}_matcher")
# end

Dir.glob(File.dirname(__FILE__) + '/matchers/*.rb').each do |rb|
  require rb
end

module Spec # :nodoc:
  module Rails
    module Matchers

      def have_button expected
        ButtonMatcher.new expected
      end

      def have_check_box_group target_name, expected
        CheckBoxGroupMatcher.new target_name, expected
      end

      def have_dropdown target_id, expected_options
        DropDownMatcher.new target_id, expected_options
      end

      def have_image expected_path
        ImageMatcher.new expected_path
      end

      def have_options expected_options
        OptionsMatcher.new expected_options
      end

      def have_radio_group target_name, expected_radio_choices
        RadioGroupMatcher.new target_name, expected_radio_choices
      end

      def have_span_text target_id, expected_text
        SpanTextMatcher.new target_id, expected_text
      end

      def have_table table_id_or_expected, expected = nil
        TableMatcher.new table_id_or_expected, expected
      end

      def have_table_header table_id_or_expected, expected = nil
        TableHeaderMatcher.new table_id_or_expected, expected
      end

      def have_table_body table_id_or_expected, expected = nil
        TableBodyMatcher.new table_id_or_expected, expected
      end

      def have_td_link target_id, expected_link, expected_text
        TdLinkMatcher.new target_id, expected_link, expected_text
      end
    end
  end
end
