class MailerWithSubdomains < ActionMailer::Base
  helper_method :url_for, :url_with_text
  def url_for(opts ={})
    return opts if opts.include?(@district.abbrev)
    raise 'set @district in mailer model method' if @district.blank?
    host = default_url_options[:host].gsub(/^www/,@district.abbrev)

    super(opts.merge(:host => host, :only_path => false))
  end

  def url_with_text text,url
    (url_for(url) + " (#{text})").html_safe
  end
end
