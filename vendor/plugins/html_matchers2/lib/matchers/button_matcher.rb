module Spec # :nodoc:
  module Rails
    module Matchers
      class ButtonMatcher
        def initialize expected_value
          # @target_id = target_id
          @expected = expected_value
        end

        def matches? response
          @actual = extract_html_content response.body
          @actual == @expected
        end

        def failure_message
          "\nWrong button value.\nexpected: #{@expected.inspect}\n   found: #{@actual.inspect}\n\n"
        end

        def negative_failure_message
          "\nShould not have matched button: #{@target_id}, with text: '#{@expected}'\n\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)
          # elements = doc.search("//input[@value='#{@expected}' & @type='button|submit']")
          # elements = doc.search("input[@value~='#{@expected}'][@type]")
          elements = doc.search("//input[@value='#{@expected}']").select{|e| ['submit', 'button'].include?(e['type'])}
          elements.map{|n| n['value']}.first
        end
      end
    end
  end
end