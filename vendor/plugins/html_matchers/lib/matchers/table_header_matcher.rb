module Spec # :nodoc:
  module Rails
    module Matchers
      class TableHeaderMatcher
        def initialize table_id_or_expected, expected
          case table_id_or_expected
          when String
            @table_id = table_id_or_expected
            @expected = expected
          when Array
            @expected = table_id_or_expected
          end
          raise 'Invalid "expected" argument' if @expected.nil?
        end

        def matches? response
          @actual = extract_html_content response.body
          @actual == @expected
        end

        def failure_message
          "\nWrong table header contents.\nexpected: #{@expected.inspect}\n   found: #{@actual.inspect}\n\n"
        end

        def negative_failure_message
          "\nTable header should not have matched: #{@expected.inspect}\n"
        end

        def extract_html_content html
          html = html.gsub(/[ \t]*<br *\/>[ \t]*/, "\n")
          doc = Hpricot.XML(html)
          elements = doc.search("table#{"##{@table_id}" if @table_id} tr")
          elements = elements.reject{|e| e.search('th').empty? }
          elements.map do |node|
            node.search('/th').map do |n|
              n.inner_text.strip.gsub(/[ \t]*\n[\n \t]*/, "\n")
            end
          end
        end
      end
    end
  end
end
