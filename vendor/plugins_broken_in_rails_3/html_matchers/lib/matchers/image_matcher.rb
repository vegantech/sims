module Spec # :nodoc:
  module Rails
    module Matchers
      class ImageMatcher
        def initialize expected_path
          @expected = expected_path
        end

        def matches? response
          @actual = extract_html_content response.body
          @actual =~ /#{@expected}/
        end

        def failure_message
          "\nWrong image path.\nexpected: #{@expected.inspect}\n   found: #{@actual.inspect}\n\n"
        end

        def negative_failure_message
          "\nShould not have matched image with path: '#{@expected}'\n\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)
          elements = doc.search("img[@src*=\"#{@expected}\"]")
          # elements.each {|e| puts e.inspect}
          # elements.first.to_html
          elements.map{|n| n.to_html}.first
        end
      end
    end
  end
end