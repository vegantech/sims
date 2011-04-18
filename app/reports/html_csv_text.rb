# Customized default formatters for ruport. Each class renders text for the 
# next immediate subclass(specified as Class.nesting[1])
class HtmlCsvText
  class HTML < Ruport::Formatter::HTML
    renders :html, :for => Class.nesting[2]
    build :header do
      output << "Report Generated at #{Time.now.to_s(:long)}"
    end

    build :body do
      output << data.to_grouping.to_html
    end

  end

  class Text < Ruport::Formatter
    renders :text, :for => Class.nesting[2]

    build :header do
      output << "Report Generated at #{Time.now.to_s(:long)}\n\n"
    end

    build :body do
      output << data.to_grouping.to_text(:ignore_table_width => true)
    end
  end

  class CSV < Ruport::Formatter::CSV
    renders :csv, :for => Class.nesting[2]

    build :body do
      output << data.to_table.to_csv
    end
  end
end
