
task "cruise" => ["default"] do
    out = ENV['CC_BUILD_ARTIFACTS']
    mkdir_p out unless File.directory? out if out
    mv 'test/coverage' "#{out}" if out

end
