begin
  RCOV_OPTS=""
  $:.unshift RAILS_ROOT+"/vendor/gems/rcov/lib"

  require 'rcov/rcovtask'
  require File.expand_path("vendor/plugins/rspec/lib//spec/rake/spectask")

  def default_rcov_params_for_unit   
    '-i "app\/reports" -x "app\/controllers","\/Library\/","spec\/","stories\/"'

  end  
  
  def default_rcov_params_for_functional   
    ' -x  "app\/reports","app\/models","app\/helpers","lib/","\/Library\/","spec\/","stories\/"'
  end
  
  def default_rcov_params_for_integration
    ' -x "\/Library\/","spec\/","stories\/"'
  end

  def specs_corresponding_to_unit
    %w( models helpers lib ).collect{|e| "spec/#{e}/*_spec.rb"}
  end
  
  def specs_corresponding_to_functional
    %w( controllers views ).collect{|e| "spec/#{e}/*_spec.rb"}
    
  end
  
  def specs_corresponding_to_integration
    "stories/all.rb"
    
  end

  def remove_coverage_data
    rm_f "coverage.data"
  end
    
  

  namespace :test do
    namespace :coverage do
      desc "Delete aggregate coverage data: requires rcov gem"
      task(:clean) { remove_coverage_data }
    end
    desc 'Aggregate code coverage for unit, functional and integration tests  and corresponding specs :requires rcov gem'
    task :coverage => ["test:coverage:clean","db:test:prepare","coverage_all"]
    
    %w[unit functional integration].each do |target|
      namespace :coverage do
        Rcov::RcovTask.new(target => ["test:coverage:clean","db:test:prepare" ]) do |t|
          t.libs << "test"
          t.test_files = FileList["test/#{target}/*_test.rb"] +
          FileList["test/#{target}/*/*_test.rb"]
          t.output_dir = "test/coverage/#{target}"
          t.verbose = true
          t.rcov_opts.clear
          t.rcov_opts << '--rails --aggregate coverage.data '
          t.rcov_opts << send("default_rcov_params_for_#{target}")
        end
      end
    end
  end
 
  namespace :spec do
    namespace :rcov do

      %w[unit functional integration].each do |target|

        desc  "coverage for test:#{target} and corresponding specs/stories-"+ send('specs_corresponding_to_'+target).to_s
        Spec::Rake::SpecTask.new(target => "test:coverage:#{target}") do |t|
          
          t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
          t.spec_files = FileList[send("specs_corresponding_to_#{target}")]
          # t.spec_files = FileList['spec/**/*_spec.rb']
          t.rcov = true
          t.rcov_dir="test/coverage/#{target}"
          t.rcov_opts << "--rails --aggregate coverage.data"
          t.rcov_opts << send("default_rcov_params_for_#{target}")
        end

      end
    end
  end
  desc 'run all Test:Unit tests, specs, and stories and generate coverage reports'
  task(:coverage_all) do
#    Rake::Task["spec:rcov:unit"].invoke
    Rake::Task["test:coverage:unit"].invoke
    remove_coverage_data
 #   Rake::Task["spec:rcov:functional"].invoke
    Rake::Task["test:coverage:functional"].invoke
    remove_coverage_data
    Rake::Task["features_with_rcov"].invoke
    
 #   Rake::Task["spec:rcov:integration"].invoke
   # Rake::Task["test:coverage:integration"].invoke
  end
                            

rescue LoadError
  #allow rake to continue to function is rcov gem is not installed
end
