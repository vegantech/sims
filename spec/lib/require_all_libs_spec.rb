require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RequireAllLibsTest < ActiveSupport::TestCase
  MyCoveralls.require_all_ruby_files(['lib'])
end
