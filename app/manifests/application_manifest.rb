require 'rubygems'
require 'active_support/core_ext/hash'

require "#{File.dirname(__FILE__)}/../../vendor/plugins/moonshine/lib/moonshine.rb"
class ApplicationManifest < Moonshine::Manifest::Rails
  # The majority of your configuration should be in <tt>config/moonshine.yml</tt>
  # If necessary, you may provide extra configuration directly in this class
  # using the configure method. The hash passed to the configure method is deep
  # merged with what is in <tt>config/moonshine.yml</tt>. This could be used,
  # for example, to store passwords and/or private keys outside of your SCM, or
  # to query a web service for configuration data.
  #
  # In the example below, the value configuration[:custom][:random] can be used in
  # your moonshine settings or templates.
  #
  # require 'net/http'
  # require 'json'
  # random = JSON::load(Net::HTTP.get(URI.parse('http://twitter.com/statuses/public_timeline.json'))).last['id']
  # configure({
  #   :custom => { :random => random  }
  # })

  def custom_networking
    file '/etc/network/interfaces',
      :ensure => :present,
      :content => template('interfaces.erb', binding),
      :group => 'root',
      :owner => 'root',
      :mode => '644'
  end

  if configuration[:network] && configuration[:network][:interfaces]
    recipe :custom_networking
  end

  recipe :scout if deploy_stage == 'production'
  recipe :xsendfile
  configure(:passenger => { :vhost_extra => """
    <Location />
        # enable tracking uploads in /
        TrackUploads On
    </Location>

    <Location /progress>
        # enable upload progress reports in /progress
        ReportUploads On
    </Location>
    """})
  recipe :upload_progress
  recipe :memcached

  # The default_stack recipe install Rails, Apache, Passenger, the database from
  # database.yml, Postfix, Cron, logrotate and NTP. See lib/moonshine/manifest/rails.rb
  # for details. To customize, remove this recipe and specify the components you want.
  recipe :default_stack

  # Add your application's custom requirements here
  def application_packages
    # If you've already told Moonshine about a package required by a gem with
    # :apt_gems in <tt>moonshine.yml</tt> you do not need to include it here.
    package 'aspell', :ensure => :installed
    package 'zip', :ensure => :installed
    package 'libxml2-dev'#, :before => exec('bundle install')
    package 'libxslt1-dev'#, :before => exec('bundle install')

    daily_jobs = "cd #{configuration[:deploy_to]}/current && bundle exec rails runner -e #{ENV['RAILS_ENV']} DailyJobs.run"
    cron 'daily_jobs', :command => daily_jobs, :user => configuration[:user], :minute => 0, :hour => 6

    weekly_jobs = "cd #{configuration[:deploy_to]}/current && bundle exec rails runner -e #{ENV['RAILS_ENV']} DailyJobs.run_weekly"
    cron 'weekly_jobs', :command => weekly_jobs, :user => configuration[:user], :minute => 0, :hour => 7, :weekday => 0

    prime_cache = "cd #{configuration[:deploy_to]}/current && nice -n15 bundle exec rails runner -e #{ENV['RAILS_ENV']}  PrimeCache.flags >> #{configuration[:deploy_to]}/current/log/prime_cache.log"
    cron 'prime_cache', :command => prime_cache, :user => configuration[:user], :minute => "*/10"

    cron 'backup_daily', :command => "/home/rails/backups/backup.sh", :hour => 8,:user => configuration[:user], :minute => 0


    # %w( root rails ).each do |user|
    #   mailalias user, :recipient => 'you@domain.com'
    # end

    # farm_config = <<-CONFIG
    #   MOOCOWS = 3
    #   HORSIES = 10
    # CONFIG
    # file '/etc/farm.conf', :ensure => :present, :content => farm_config

    # Logs for Rails, MySQL, and Apache are rotated by default
    # logrotate '/var/log/some_service.log', :options => %w(weekly missingok compress), :postrotate => '/etc/init.d/some_service restart'
    configure(:rails_logrotate => {:options => %w(daily missingok compress delaycompress sharedscripts rotate\ 52 ) })

    # Only run the following on the 'testing' stage using capistrano-ext's multistage functionality.
    # on_stage 'testing' do
    #   file '/etc/motd', :ensure => :file, :content => "Welcome to the TEST server!"
    # end
    exec 'hostname > /tmp/hostname'
  end
  # The following line includes the 'application_packages' recipe defined above
  recipe :application_packages
end
