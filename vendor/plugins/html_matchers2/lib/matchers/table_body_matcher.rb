module Spec # :nodoc:
  module Rails
    module Matchers
      class TableBodyMatcher

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
          "\nWrong table body contents.\nexpected: #{@expected.inspect}\n   found: #{@actual.inspect}\n\n"
        end

        def negative_failure_message
          "\nTable body should not have matched: #{@expected.inspect}\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)
          elements = doc.search("table#{"##{@table_id}" if @table_id} tr").reject{|e| e.search('td').empty? }
          elements.map{|n| n.search('/td').map{|n| n.inner_text.strip.gsub(/[ \t]*\n[\n \t]*/, "\n")}}
        end

      end
    end
  end
end
