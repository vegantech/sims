class MailerWithSubdomains < ActionMailer::Base
  def url_for(opts ={})
    raise 'set @district in mailer model method' if @district.blank?
    host = default_url_options[:host].gsub(/^www/,@district.abbrev)

    super(opts.merge(:host => host))

  end

end
