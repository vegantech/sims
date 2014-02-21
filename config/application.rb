require File.expand_path('../boot', __FILE__)

require 'rails/all'
require File.expand_path('../../lib/best_standards_support',__FILE__)

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end


module Sims
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
     config.autoload_paths += %W(
       #{config.root}/lib
       #{config.root}/app/reports
       #{config.root}/app/controllers/concerns
       #{config.root}/app/models/concerns
     )
     config.active_record.observers = :principal_override_observer , :recommendation_observer

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.i18n.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.middleware.swap ActionDispatch::BestStandardsSupport, Sims::BestStandardsSupport

#    config.action_mailer.delivery_method = :railmail
    config.time_zone = 'Central Time (US & Canada)'
    config.cache_store = :dalli_store
    config.paths['app/manifests'] = "app/manifests"
    config.paths['app/manifests'].skip_eager_load!

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += %w( tablesort.js print.css screen.css pdf.css googiespell.css spellerStyle.css jquery.js jquery.uploadProgress.js )
    config.assets.precompile += ["*lang/*", "*spellerpages/*"]
    # Change the path that assets are served from
    # # config.assets.prefix = "/assets"
    config.action_mailer.raise_delivery_errors = false

    config.generators do |g|
      g.fixture_replacement :factory_girl
    end



    config.to_prepare do
      Devise::Mailer.layout "email"
    end
  end
end

