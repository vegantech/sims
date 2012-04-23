begin
  h=Object.const_get("SIMS_DOMAIN") 
rescue NameError
  h='example.com'
end

size = h.split(".").length() -1

SubdomainFu.tld_sizes = {:development => 0,
                         :development_with_cache => 0,
                         :test => 1,
                         :wip => size,
                         :veg_open => size,
                         :production => size,
                         :staging => size,
                         :cucumber => 1
                         }
SubdomainFu.mirrors = 'www'
SubdomainFu.preferred_mirror = "www"
 
