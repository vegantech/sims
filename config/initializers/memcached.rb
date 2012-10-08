begin
  require 'memcache'
  MEMCACHE = MemCache.new('localhost:11211', :timeout => 1)
  unless MEMCACHE.servers.first.alive?
    puts 'MEMCACHE SERVER DEAD' + MEMCACHE.servers.inspect
    MEMCACHE = nil
  end
  MEMCACHE.stats
rescue 
  puts 'Memcache could not be loaded' + $!
  MEMCACHE = nil
end
#periodically call remote, update status
