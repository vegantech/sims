require File.dirname(__FILE__)+ '/rcov_rake_helper'
require File.expand_path("vendor/plugins/rspec/lib/spec/rake/verify_rcov")

Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
def remove_task(task_name)
    Rake.application.remove_task(task_name)
end
 



remove_task :default
task "default" => ["test:coverage"]

task "verify_rcov" => [:verify_rcov_unit, :verify_rcov_functional, :verify_rcov_integration] 
task "test:coverage" => [:verify_rcov]

# http://vegantech.lighthouseapp.com/projects/17513/tickets/23-tested-70-unit-60-functional-50-integration

RCov::VerifyTask.new('verify_rcov_unit') do |t|
  t.require_exact_threshold=false
  t.threshold = 50.0  # Make sure you have rcov 0.7 or higher! 
  t.index_html = 'test/coverage/unit/index.html'
end

RCov::VerifyTask.new('verify_rcov_functional') do |t|
  t.require_exact_threshold=false
  t.threshold = 50.0 # Make sure you have rcov 0.7 or higher!
  t.index_html = 'test/coverage/functional/index.html'
end

RCov::VerifyTask.new('verify_rcov_integration') do |t|
  t.require_exact_threshold=false
  t.threshold = 40.0 # Make sure you have rcov 0.7 or higher!
  t.index_html = 'test/coverage/integration/index.html'
end
