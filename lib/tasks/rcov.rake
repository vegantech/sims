begin
  require File.dirname(__FILE__)+ '/rcov_rake_helper'
   
  
if defined? Rcov
  
  namespace :test do
    namespace :coverage do
      desc "Delete aggregate coverage data: requires rcov gem"
      task(:clean) { remove_coverage_data }

      task(:unit) {puts "Test:unit tests disabled use rspec"}
      task(:functional) {puts "test:unit functional tests disabled use rspec"}
      task(:integration) {puts "test:unit integration tests disabled use cucumber"}
    end
    desc 'Aggregate code coverage for unit, functional and integration tests  and corresponding specs :requires rcov gem'
    task :coverage => ["test:coverage:clean","db:test:prepare","coverage_all"]
    
 end
  namespace :spec do
    #run the unit tests before the specs and show coverage
    namespace :rcov do
      %w[unit functional integration].each do |target|

        desc  "coverage for test:#{target} and corresponding specs/stories-"+ send('specs_corresponding_to_'+target).to_s
        Spec::Rake::SpecTask.new(target => "test:coverage:#{target}") do |t|
          
          t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
          t.spec_files = FileList[send("specs_corresponding_to_#{target}")]
          # t.spec_files = FileList['spec/**/*_spec.rb']
          t.rcov = true
          t.rcov_dir="test/coverage/#{target}"
          t.rcov_opts << "--rails --aggregate coverage.data --text-report --sort coverage"
          t.rcov_opts << send("default_rcov_params_for_#{target}")
        end

      end
    end
  end
  desc 'run all Test:Unit tests, specs, and stories and generate coverage reports'
  task(:coverage_all) do
    Rake::Task["spec:rcov:unit"].invoke
    remove_coverage_data
   Rake::Task["spec:rcov:functional"].invoke
    remove_coverage_data
    Rake::Task["features_with_rcov"].invoke
    #using cucumber instead of rspec stories
  end
                            
end
rescue LoadError
  #allow rake to continue to function is rcov gem is not installed
end
