begin
  h=Object.const_get("SIMS_DOMAIN") 
rescue NameError
  h='example.com'
end

size = h.split(".").length() -1

SubdomainFu.tld_sizes = {:development => 0,
                         :test => 1,
                         :production => size,
                         :cucumber => 1
                         }
SubdomainFu.mirrors = 'www'
SubdomainFu.preferred_mirror = "www"
 
