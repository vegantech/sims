require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RequireAllControllersTest < ActiveSupport::TestCase
  Coveralls.require_all_ruby_files(['app/controllers','app/metals','app/cells','app/sweepers'])
end
