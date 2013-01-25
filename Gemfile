source "http://bundler-api.herokuapp.com"
source :rubygems

gem 'rails', '3.1.10'

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


gem 'factory_girl_rails', '~> 1.7.0'
gem 'redcarpet'
gem 'googlecharts','1.6.3'
gem 'airbrake'
gem 'rails_responds_to_parent'#,'0.0.0', :git => 'git://github.com/itkin/respond_to_parent.git'
gem 'mysql2', ">= 0.3.12b4"
gem 'nokogiri','1.4.4', :require => false
gem 'rdoc', '>2.4.2', :require => false
gem 'memcache-client'
gem 'cells'
gem 'paperclip', '~> 2.7.0'
gem "spawn", :git => 'git://github.com/rfc2822/spawn'
gem 'dynamic_form'
gem 'acts_as_list'
gem 'will_paginate'
gem 'pdfkit'
gem 'statistics'
gem 'devise', '~> 1.5.0'
gem 'omniauth-google-apps'
gem 'omniauth-windowslive'
gem 'railmail', :git => "git://github.com/vegantech/railmail.git", :group => [:wip, :staging, :veg_open, :development, :test,:development_with_cache], :branch => "skip_authorize_and_authenticate"
gem 'rinku', :group => [:wip, :staging, :veg_open, :development, :test,:development_with_cache], :require => "rails_rinku"
gem 'sneaky-save'
gem 'jquery-rails'
gem "jquery-scrollto-rails"
gem 'jquery-ui-rails'
gem 'awesome_nested_fields'



group :test do
  gem 'simplecov', :require => false
  gem 'capybara', :require => false
  gem 'rspec-rails','~>2.6', :require => false
  gem 'rspec-html-matchers'
end

group :cucumber do
  gem 'simplecov',  :require => false
  gem 'capybara', :require => false
  gem 'cucumber-rails', :require => false
  gem 'rack-test', :require => 'rack/test'
  gem 'database_cleaner','>=0.5.0', :require => false
  gem 'email_spec','=1.2.1', :require => false
  gem 'launchy'
  gem 'rspec-rails','~>2.6', :require => false
  gem 'sauce'
  gem 'sauce-cucumber'
end

group :development do
  gem "capistrano", :require => false
  gem "capistrano-ext", :require => false
  gem "thin"
  gem "metrical", :platforms => :ruby_19
  #gem "ripper", :platforms => :ruby_19
  gem 'rspec-rails','~>2.6', :require => false
  gem 'spork'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'rb-inotify'
  gem 'libnotify'
end


group :assets do
  gem 'sass-rails',   "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'rpm_contrib'
gem 'newrelic_rpm'
