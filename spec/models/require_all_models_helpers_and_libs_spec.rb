require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RequireAllModelsHelpersandLibsSpec
  Coveralls.require_all_ruby_files(['/lib', '/app/models', '/app/helpers', '/app/reports'])
end
