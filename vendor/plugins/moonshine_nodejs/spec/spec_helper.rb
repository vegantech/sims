require 'rubygems'
require File.join(File.dirname(__FILE__), '..', '..', 'moonshine', 'lib', 'moonshine.rb')
require 'moonshine/matchers'
require 'shadow_puppet/test'

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'


require File.join(File.dirname(__FILE__), '..', 'lib', 'moonshine', 'nodejs.rb')

require 'shadow_puppet/test'

class NodejsManifest < Moonshine::Manifest::Rails
  path = Pathname.new(__FILE__).dirname.join('..', 'moonshine', 'init.rb')
  Kernel.eval(File.read(path), binding, path)
end

# require 'rubygems'
# require 'isolate/scenarios'
# require 'isolate/now'

# # Requires supporting files with custom matchers and macros, etc,
# # in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# require 'moonshine'
# require 'moonshine/matchers'
# require 'shadow_puppet/test'

# Spec::Runner.configure do |config|
#   config.include Moonshine::Matchers
#   config.include Capistrano::Spec::Matchers
#   config.include Capistrano::Spec::Helpers
#   config.include MoonshineHelpers
#   config.extend MoonshineHelpers::ClassMethods
# end
