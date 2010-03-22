module Spec # :nodoc:
  module Rails
    module Matchers
      class OptionsMatcher
        def initialize expected
          @expected = expected
        end

        def matches? response
          @actual = extract_html_content response.body
          @actual == @expected
        end

        def failure_message
          "\nWrong option contents.\nexpected: #{@expected.inspect}\n   found: #{@actual.inspect}\n\n"
        end

        def negative_failure_message
          "\nShould not have matched contents: #{@expected.inspect}\n\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)
          doc.search("/option").map{|n| n.inner_text.strip}
        end
      end
    end
  end
end
