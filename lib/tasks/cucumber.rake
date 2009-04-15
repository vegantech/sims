$LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
begin
  require 'cucumber/rake/task'
  require File.dirname(__FILE__)+ '/rcov_rake_helper'

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format progress"
  end
  task :features => 'db:test:prepare'


  Cucumber::Rake::Task.new(:features_with_rcov=>["test:coverage:clean","db:test:prepare" ]) do |t|
    
    target = "integration"
    t.cucumber_opts = "--format progress"
    t.rcov = true
    t.rcov_opts << "-o test/coverage/#{target}"
    t.rcov_opts << "--rails --aggregate coverage.data --text-report --sort coverage"
    t.rcov_opts << send("default_rcov_params_for_#{target}")

  end
  task :features_with_rcov => ['db:test:prepare']
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
