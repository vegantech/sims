begin
  require 'memcache'
  MEMCACHE = MemCache.new('127.0.0.1:11211')
  unless MEMCACHE.servers.first.alive?
    puts 'MEMCACHE SERVER DEAD'
    MEMCACHE = nil
  end
  MEMCACHE.stats
rescue 
  puts 'Memcache could not be loaded' + $!
  MEMCACHE = nil
end
#periodically call remote, update status
