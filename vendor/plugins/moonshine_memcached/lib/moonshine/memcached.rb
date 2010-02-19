module Moonshine
  module Memcached

    # Define options for this plugin via the <tt>configure</tt> method
    # in your application manifest:
    #
    #   configure(:memcached => {:foo => true})
    #
    # Then include the plugin and call the recipe(s) you need:
    #
    #  plugin :memcached
    #  recipe :memcached
    def memcached(options = {})
      options = { :enable_on_boot => true }.merge(options)

      package 'memcached', :ensure => :installed
      service 'memcached', :ensure => :running, :enable => options[:enable_on_boot], :require => package('memcached')
    
      file '/etc/memcached.conf', 
        :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'memcached.conf.erb'), binding),
        :mode => '644',
        :require => package('memcached'),
        :notify => service('memcached')
    
      # install client gem if specified. otherwise, use version bundled with rails.
      if options[:client]
        gem 'memcache-client', :require => package('memcached'), :version => options[:client]
      end
    
    end
  
  end
end