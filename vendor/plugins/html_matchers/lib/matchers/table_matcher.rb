module Spec # :nodoc:
  module Rails
    module Matchers
      class TableMatcher

        def initialize table_selector_or_expected, expected
          case table_selector_or_expected
          when String
            @table_selector = table_selector_or_expected
            @expected = expected
          when Array
            @expected = table_selector_or_expected
          end
          raise 'Invalid "expected" argument' if @expected.nil?
        end

        def matches? response
          @actual = extract_html_content response.body
          @actual == @expected
        end

        def failure_message
          "\nWrong table contents.\nexpected: #{@expected.inspect.gsub('], [', "],\n[")}\n   found: #{@actual.inspect.gsub('], [', "],\n[")}\n\n"
        end

       def negative_failure_message
          "\nTable should not have matched: #{@expected.inspect}\n"
        end

        def extract_html_content html
          doc = Hpricot.XML(html)

          rows = doc.search("table#{"#{@table_selector}" if @table_selector} tr")
          header_elements = rows.reject{|e| e.search('th').empty? }
          header_content = header_elements.map do |header_element|
            header_element.search('/th').map do |n|
              stripped = n.inner_html.gsub(/<script.*<\/script>/m, '')
              temp_node = Hpricot.XML("<temp-node>#{stripped}</temp-node>")
              temp_node.inner_text.strip.gsub(/[ \t]*\n[\n \t]*/, "\n")
            end
          end

          body_elements = rows.reject{|e| e.search('td').empty? }
          body_content = body_elements.map do |body_element|
            body_element.search('/td').map do |n|
              stripped = n.inner_html.gsub(/<script.*<\/script>/m, '')
              temp_node = Hpricot.XML("<temp-node>#{stripped}</temp-node>")
              temp_node.inner_text.strip.gsub(/[ \t]*\n[\n \t]*/, "\n")
            end
          end

          header_content + body_content
        end
      end
    end
  end
end