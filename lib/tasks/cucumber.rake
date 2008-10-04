$:.unshift "./vendor/gems/rcov/lib"
$:.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
$:.unshift (RAILS_ROOT + '/vendor/gems/rcov-0.8.1.3.0/lib')

require 'cucumber/rake/task'
load File.dirname(__FILE__)+ '/rcov.rake'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end
task :features => 'db:test:prepare'


Cucumber::Rake::Task.new(:features_with_rcov) do |t|
  
  target = "integration"
  t.rcov = true
  t.rcov_opts << "-o test/coverage/#{target}"
  t.rcov_opts << "--rails --aggregate coverage.data"
  t.rcov_opts << send("default_rcov_params_for_#{target}")

end
task :features_with_rcov => 'db:test:prepare'
