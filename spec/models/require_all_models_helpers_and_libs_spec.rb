require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RequireAllModelsHelpersandLibsSpec
  MyCoveralls.require_all_ruby_files(['lib', 'app/models', 'app/helpers', 'app/reports', 'app/mailers'])
end
