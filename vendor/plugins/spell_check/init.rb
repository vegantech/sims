# Include hook code here
require 'spell_check'
=begin
%w{helpers }.each do |dir|
  path = File.join(directory, 'lib', dir)
  $LOAD_PATH << path
  Dependencies.load_paths << path
  Dependencies.load_once_paths.delete(path)
end

=end
if ActionController::Base.respond_to?(:append_view_path) then
  ActionController::Base.append_view_path File.join(File.dirname(__FILE__),'lib','views')
elsif ActionController::Base.respond_to?(:view_paths)
  ActionController::Base.view_paths << 'lib/views'
else
  #  puts "using views/spell_check for spell_check partials"
end
