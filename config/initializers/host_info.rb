#SIMS_DOMAIN = #sims-open.vegantech.com
SIMS_PROTO="http"  #change to https when we're using that.
#DEFAULT_URL = #'http://www.simspilot2.org:3000'

sessionhash= {
    :key         => '_sims-open4_session',
    :secure => (Rails.env.production? || Rails.env.staging? )
    }

if ENV['SIMS_DOMAIN']
  SIMS_DOMAIN = ENV['SIMS_DOMAIN']
end

if defined?(SIMS_DOMAIN)
  sessionhash.merge!( :domain =>  ".#{SIMS_DOMAIN}")
else
  sessionhash.merge!( :domain => ".lvh.me")
end

Sims::Application.config.session_store :cookie_store, sessionhash
if Object.const_defined?('SIMS_DOMAIN')
  ActionDispatch::Http::URL.tld_length = (SIMS_DOMAIN.split(".").length() -1)  #defaults to 1
  host="www.#{Object.const_get("SIMS_DOMAIN")}"
end
ActionMailer::Base.default_url_options = {
  :only_path => false,
  :protocol => SIMS_PROTO,
  :host => host ||"www.sims_test_host"
}
