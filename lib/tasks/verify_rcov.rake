begin
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
#task "default" => ["spec", "features"]
remove_task :test
task "test" => ["spec", "features"]

task "verify_rcov" => [:verify_rcov_unit, :verify_rcov_functional, :verify_rcov_integration] 
task "test:coverage" => [:verify_rcov]

def index_base_path
  (ENV['CC_BUILD_ARTIFACTS'] || 'test/coverage') 
end
  

#http://vegantech.lighthouseapp.com/projects/17513/tickets/176-test-coverage-775-unit-775-functional-675-integration
RCov::VerifyTask.new('verify_rcov_unit') do |t|
  t.require_exact_threshold=false
  t.threshold = 56  #now doind code instead of total coverage
  t.index_html = index_base_path + '/unit/index.html'
end

RCov::VerifyTask.new('verify_rcov_functional') do |t|
  t.require_exact_threshold=false
  t.threshold = 70.7 #79.0 # Make sure you have rcov 0.7 or higher!
  t.index_html = index_base_path + '/functional/index.html'
end

RCov::VerifyTask.new('verify_rcov_integration') do |t|
  t.require_exact_threshold=false
  t.threshold = 57.0 # Make sure you have rcov 0.7 or higher!
  t.index_html = index_base_path + '/integration/index.html'
end
task "default" => ["test:coverage"]
rescue LoadError
end
