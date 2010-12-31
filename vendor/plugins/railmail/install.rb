Dir.chdir File.join(File.dirname(__FILE__), '../../..') do
  `rake railmail:install`
end