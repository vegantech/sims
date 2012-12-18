#
#
# Moonshine will autoload plugins, just call the recipe(s) you need in your
# manifests:
#
#    recipe :nodejs
#

module Moonshine
  module Nodejs
    def nodejs
      file '/etc/apt/sources.list.d/nodejs.list',
        :ensure => :present,
        :mode => '644',
        :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'nodejs.list.erb'), binding)
      
      exec 'ppa:chris-lea/node.js apt-key',
        :command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv C7917B12',
        :unless => 'apt-key list | grep C7917B12',
        :logoutput => :on_failure
      
      exec 'apt-get update',
        :command => 'apt-get update',
        :require => [
          file('/etc/apt/sources.list.d/nodejs.list'),
          exec('ppa:chris-lea/node.js apt-key')
        ],
        :logoutput => :on_failure
      
      package :nodejs, :ensure => :installed
    end
  end
end
