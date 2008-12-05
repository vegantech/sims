# Loads the default ruport formatters.
class DefaultReport < Ruport::Controller
  stage :header, :body
  def self.load_html_csv_text
    class_eval File.read("#{File.dirname(__FILE__)}/html_csv_text.rb")
  end
end