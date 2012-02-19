require 'rake'
require 'spec/rake/spectask'
# require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run spec tests.'
task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
  # unless ENV['NO_RCOV']
  #   t.rcov = true
  #   t.rcov_dir = 'coverage'
  #   t.rcov_opts = ['--exclude', 'lib/spec.rb,lib/spec/runner.rb,spec\/spec,bin\/spec,examples,\/var\/lib\/gems,\/Library\/Ruby,\.autotest']
  # end
end

desc 'Generate documentation for the html_matchers plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HtmlMatchers'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end