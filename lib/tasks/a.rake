  task :build_rcov_gem_binaries do
  require 'ftools'
    unless File.exists?('rcovrt.so')
      Rake::Task["gems:build"].invoke
      File.copy( RAILS_ROOT + '/vendor/gems/rcov-0.8.1.3.0/bin/rcovrt.so', RAILS_ROOT)
    end
  end

