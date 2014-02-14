require 'open-uri'
require 'net/https'

module Net
  class HTTP
    alias_method :original_use_ssl_before_fix=, :use_ssl= unless method_defined? :original_use_ssl_before_fix=
    def use_ssl=(flag)
      #self.ca_file = Rails.root.join("lib", "ca-bundle.crt").to_s
      #self.verify_mode = OpenSSL::SSL::VERIFY_PEER # ruby default is VERIFY_NONE!
      self.original_use_ssl_before_fix = flag
    end
  end
end
