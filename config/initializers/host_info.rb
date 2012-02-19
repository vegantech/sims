

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Sims::Application.config.session_store :active_record_store


#SIMS_DOMAIN = #sims-open.vegantech.com
SIMS_PROTO="http"  #change to https when we're using that.
#DEFAULT_URL = #'http://www.simspilot2.org:3000'


# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#
#
secret_file = Rails.root.join("config","secret")
if File.exist?(secret_file)
  secret=File.read(secret_file)
else
  secret = '9df9dcab8db4a1ccd72c79b014440d19d31042f8f6bcbec04c6c940c034d1cb210073b5613d0873544133aef0e5c21f197018d9a7ed23afbef31bc52b38c68ad'
end
sessionhash= {
    :key         => '_sims-open2_session',
    :secret      => secret
    }

if defined?(SIMS_DOMAIN)
  sessionhash.merge!( :domain =>  ".#{SIMS_DOMAIN}")
else
  sessionhash.merge!( :domain => ".lvh.me")
end

Sims::Application.config.session_store :cookie_store, sessionhash
if Object.const_defined?('SIMS_DOMAIN')

  SIMS_DOMAIN_LENGTH = (SIMS_DOMAIN.split(".").length() -1)
  host="www.#{Object.const_get("SIMS_DOMAIN")}"
else
  SIMS_DOMAIN_LENGTH = 1
end
ActionMailer::Base.default_url_options = {
  :only_path => false,
  :protocol => SIMS_PROTO,
  :host => host ||"www.sims_test_host"
}
