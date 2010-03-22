module Spec # :nodoc:
  module Rails
    module Matchers
      class RadioGroupMatcher
        def initialize target_name, expected
          @expected = expected
          @target_name = target_name
        end

        def matches? response
          @actual = extract_html_content response.body
          @actual == @expected
        end

        def failure_message
          "\nWrong radio group contents.\nexpected: #{@expected.inspect}\n   found: #{@actual.inspect}\n\n"
        end

        def negative_failure_message
          "\nShould not have matched radio group: name: #{@target_name}, with: #{@expected.inspect}\n\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)
          elements = doc.search('input')
          elements = elements.select{|n| n.elem? && n.get_attribute('name') == @target_name}
          elements.map{|n| n.get_attribute('value')}
        end
      end
    end
  end
end