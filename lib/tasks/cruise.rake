
task "cruise" => ["db:migrate","default"] do
  #    out = ENV['CC_BUILD_ARTIFACTS']
  #    mkdir_p out unless File.directory? out if out
  #    puts out if out
  #    mv 'test/coverage', "#{out}/coverage" if out
  #    mv 'tmp/metric_fu/output', "#{out}/metric_fu" if out

end
