begin
  require 'memcache'
  MEMCACHE = MemCache.new('127.0.0.1')
  unless MEMCACHE.servers.first.alive?
    puts 'MEMCACHE SERVER DEAD' + MEMCACHE.servers.inspect
    MEMCACHE = nil
  end
  

rescue 
  puts 'Memcache could not be loaded' + $!
  MEMCACHE = nil
end
#periodically call remote, update status
