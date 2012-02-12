source 'http://rubygems.org'

gem 'rails', '3.0.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end


gem 'factory_girl_rails'
gem 'ruport','1.6.1'
gem 'acts_as_reportable','1.1.1', :require => 'ruport/acts_as_reportable'
gem 'bluecloth','> 2.0.0'
gem "fastercsv", '1.2.3'
gem "pdf-writer", :require => "pdf/writer"
gem 'system_timer'
gem 'googlecharts','1.6.3'
gem 'airbrake'
gem 'rails_responds_to_parent'#,'0.0.0', :git => 'git://github.com/itkin/respond_to_parent.git'
gem 'mysql2', '~> 0.2.7'
gem 'nokogiri','1.4.4', :require => false
gem 'rdoc', '>2.4.2', :require => false
gem 'memcache-client'
gem 'cells'
gem 'paperclip'
gem "spawn", :git => 'git://github.com/rfc2822/spawn'
gem 'prototype_legacy_helper', '0.0.0', :git => 'git://github.com/rails/prototype_legacy_helper.git'
gem 'dynamic_form'
gem 'railmail', :git => "https://github.com/zonecheung/railmail.git"

group :test do
  gem 'rcov', ">=0.9.9", :require => false
  gem 'capybara', :require => false
  gem 'rspec-rails','~>2.6', :require => false
  gem 'sneaky-save'
  gem 'rspec-html-matchers'
end

group :cucumber do
  gem 'rcov', ">=0.9.9", :require => false
  gem 'capybara', :require => false
  gem 'cucumber-rails', :require => false
  gem 'cucumber', :require => false#covered by cucumber-rails above
  gem 'rack-test', :require => 'rack/test'
  gem 'database_cleaner','>=0.5.0', :require => false
  gem 'email_spec','=1.2.1', :require => false
  gem 'launchy'
  gem 'rspec-rails','~>2.6', :require => false
end

group :development do
gem "capistrano",'2.5.0', :require => false
gem "capistrano-ext", :require => false
gem "thin"
gem "metrical", :platforms => :ruby_19
gem "ripper", :platforms => :ruby_19
gem 'rspec-rails','~>2.6', :require => false
end


gem 'rpm_contrib'
gem 'newrelic_rpm'
