source :rubygems
gem 'rails','2.3.14'
gem 'factory_girl', "1.2.1"
gem 'ruport','1.6.1'
gem 'acts_as_reportable','1.1.1', :require => 'ruport/acts_as_reportable'
gem 'bluecloth','> 2.0.0'
gem "fastercsv", '1.2.3'
gem "pdf-writer", :require => "pdf/writer"
gem 'rack','>= 1.0.0'
gem 'system_timer'
gem 'googlecharts','1.6.3'
gem 'airbrake',"~> 3.0.5"
gem 'responds_to_parent'
gem 'newrelic_rpm', "2.14.1"
gem 'mysql'
gem 'nokogiri','1.4.4', :require => false

group :test do
  gem 'rcov', ">=0.9.9", :require => false
  gem 'hpricot','0.6.161', :require => false
  gem 'rspec-rails','1.3.4', :require => false
end

group :cucumber do
  gem 'rcov', ">=0.9.9", :require => false
  gem 'cucumber-rails','=0.3.2', :require => false
  gem 'cucumber','=1.1.4', :require => false#covered by cucumber-rails above
  gem 'rack-test', :require => 'rack/test'
  gem 'database_cleaner','>=0.5.0', :require => false
  gem 'webrat','>=0.7.0', :require => false
  gem 'rspec-rails', '=1.3.4', :require => false
  gem 'hpricot','0.6.161', :require => false
  gem 'email_spec',"0.6.6", :require => false
end

group :development do
gem "capistrano", :require => false
gem "capistrano-ext", :require => false
end
