module Spec # :nodoc:
  module Rails
    module Matchers
      class TdLinkMatcher

        def initialize target_id, expected_text, expected_link
          @xpath = "td##{target_id}"
          @expected_link = expected_link
          @expected_text = expected_text
        end

        def matches? response
          @actual_text = extract_html_content response.body
          @actual_text == @expected_text
        end

        def failure_message
          "\nWrong #{@element_name} contents.\nexpected: #{@expected_text.inspect}\n   found: #{@actual_text.inspect}\n\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)
          elements = doc.search(@xpath)
          elements.map{|n| n.inner_text.strip}.first
        end

      end
    end
  end
end