begin
  h=Object.const_get("SIMS_DOMAIN") 
rescue NameError
  h='www.sims_test_host'
end
SubdomainFu.tld_size = h.split(".").length() -1
SubdomainFu.mirrors = 'www'
SubdomainFu.preferred_mirror = "www"
 
