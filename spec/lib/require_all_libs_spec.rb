require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RequireAllLibsTest < ActiveSupport::TestCase
  Coveralls.require_all_ruby_files(['lib'])
end
