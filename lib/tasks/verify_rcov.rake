require 'lib/tasks/verify_rcov'

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

#Lowering these until I integrate rspec   +10  turns out integration test coverage was including unit and functional
RCov::VerifyTask.new('verify_rcov_unit') do |t|
  t.threshold = 12.9 # Make sure you have rcov 0.7 or higher!  note ticket #52 in track
  t.index_html = 'test/coverage/unit/index.html'
end

RCov::VerifyTask.new('verify_rcov_functional') do |t|
  t.threshold = 10.0 # Make sure you have rcov 0.7 or higher!
  t.index_html = 'test/coverage/functional/index.html'
end

RCov::VerifyTask.new('verify_rcov_integration') do |t|
  t.threshold = 10.0 # Make sure you have rcov 0.7 or higher!
  t.index_html = 'test/coverage/integration/index.html'
end
