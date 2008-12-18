require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RequireAllModelsHelpersandLibsSpec < Test::Unit::TestCase

  # Method to require all ruby classes when calculating code coverage.
  # Call this to not leave untested files out of the code coverage percentages.
  def self.require_all_ruby_files target_dirs
    Array(target_dirs).each do |target_dir|
      Dir.glob("RAILS_ROOT/#{target_dir}/**/*.rb").each do |ruby_file|
        e = ruby_file.split("#{target_dir}/").last.split(".rb").first 
        begin
          # trigger the normal Rails mechanism to require files
          e.classify.constantize
        rescue
          # handle the few exceptions
          require e
        end
      end
    end
  end

  require_all_ruby_files(['/lib', '/app/models', '/app/helpers', '/app/reports'])
end
