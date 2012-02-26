PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf'
  config.default_options = {
    :margin_top => "0.25in",
    :margin_left => "0.25in",
    :margin_right => "0.25in",
    :margin_bottom => "0.25in",
    :page_size => 'Legal',
    :footer_center => "Page: [page] of [topage]"
  }

end
