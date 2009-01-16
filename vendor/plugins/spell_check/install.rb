# Install hook code here
require 'ftools'
if ActionController::Base.respond_to?(:append_view_paths) then
  puts "You can override the default display by creating views/spell_check"
elsif ActionController::Base.respond_to?(:view_paths)
  puts "You can override the default display by creating views/spell_check"
else
  Dir.mkdir( RAILS_ROOT + '/app/views/spell_check') unless File.exists?(RAILS_ROOT + '/app/views/spell_check')
  Dir.glob(File.dirname(__FILE__)+'/lib/views/spell_check/*.rhtml').each do |f|
    File.copy(f, RAILS_ROOT + '/app/views/spell_check/',true)
  end
end
