begin
  require 'memcache'
  MEMCACHE = MemCache.new('127.0.0.1')
  MEMCACHE.stats
rescue 
  puts 'Memcache could not be loaded or server not running'
  MEMCACHE = nil
end

#periodically call remote, update status
