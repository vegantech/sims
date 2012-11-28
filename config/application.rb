require File.expand_path('../boot', __FILE__)

require 'rails/all'
require File.expand_path('../../lib/best_standards_support',__FILE__)

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Sims
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
     config.autoload_paths += %W(#{config.root}/lib)
     config.autoload_paths += %W(#{config.root}/app/reports)
     config.active_record.observers = :principal_override_observer , :recommendation_observer

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
=begin
     SIMS_BASE_PLUGINS = [:validates_date_time, :acts_as_list,  :paperclip,
       :spawn, :statistics,  :unobtrusive_date_picker, :will_paginate, :airbrake, :mysql_sets]
       if ENV['RAILS_ENV'] == "test" || ENV['RAILS_ENV'] == 'cucumber'
         config.plugins =  [ :validates_date_time, :all ]
       elsif ENV['RAILS_ENV'] == "production"
         config.plugins =  SIMS_BASE_PLUGINS
       else
         config.plugins =  SIMS_BASE_PLUGINS# | [:railmail]
       end
=end
    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.middleware.use 'ExtendedLogger'
    config.middleware.swap ActionDispatch::BestStandardsSupport, Sims::BestStandardsSupport

#    config.action_mailer.delivery_method = :railmail
    config.time_zone = 'Central Time (US & Canada)'
    config.cache_store = :mem_cache_store
    config.paths['app/manifests'] = "app/manifests"
    config.paths['app/manifests'].skip_eager_load!

    config.to_prepare do
      Devise::Mailer.layout "email"
    end
  end
end

