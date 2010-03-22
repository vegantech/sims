module Spec # :nodoc:
  module Rails
    module Matchers
      class CheckBoxGroupMatcher

        def initialize target_name, expected
          @expected = expected
          @target_name = target_name
        end

        def matches? response
          @actual = extract_html_content response.body
          @actual == @expected
        end

        def failure_message
          "\nWrong check box group contents.\nexpected: #{@expected.inspect}\n   found: #{@actual.inspect}\n\n"
        end

        def negative_failure_message
          "\nShould not have matched check box group: name: #{@target_name}, with: #{@expected.inspect}\n\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)
          # elements = doc.search('div input[type="checkbox"]')
          elements = doc.search('div/input')
          elements = elements.select{|n| n.elem? && n.get_attribute('type') == 'checkbox' && n.get_attribute('name') == @target_name}
          elements.map{|n| value = n.get_attribute('value'); [value, find_label(n)]}
        end

      private

        def find_label node
          label_node = node.next_sibling
          label_node.inner_text
        end

      end
    end
  end
end