
class StudentVerificationError < StandardError; end
class VerifyStudentInDistrictExternally
  require 'net/https'
  require 'uri'
  require 'nokogiri'
  require 'timeout'
  require 'yaml'





  def self.enabled?
    if defined?@@enabled
      @@enabled
    else
      setup
    end
  end

  def self.setup
    file = File.join(Rails.root,"config","external_student_location_verify.yml")
    if File.exist?(file)
      @@config = YAML::load_file(file)
    else
      @@enabled = false
    end
  end



  def self.verify(student,district)
    if enabled?
      verify_externally(student,district)
    else
      raise StudentVerificationError, 'External Verification is not enabled'
    end

  end

#true return true
#false return false
#error raise exception

  def self.verify_externally(student,district)

#   curl "https://uaapps.dpi.wi.gov/SIMS_Student_Location_Confirm/SIMS/nonsecure"
 #  -d wsn=9000000099 -d district=3456 -H "Accept: text/xml"

   #uri = URI.parse("https://uaapps.dpi.wi.gov/SIMS_Student_Location_Confirm/SIMS/nonsecure")
   uri = URI.parse(@@config['url'])
   http=Net::HTTP.new(uri.host, uri.port)
   http.use_ssl=true
   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

   request = Net::HTTP::Post.new(uri.request_uri)
   #request.basic_auth("xxx", "yyy")
   request.set_form_data({"district" => "#{district}", "wsn"=>"#{student}"})
   request["Accept"]="text/xml"
   request["Auth-token"]= @@config['token']
   request["Cookie"] = Rails.cache.read "ext_verify_cookie"

   #set timeout here
   retries =2
   begin
     timeout(5) do
     @@response=http.request(request)
   end
   rescue TimeoutError
     if retries >0
       retries -=1
       retry
     else
       raise StudentVerificationError, 'Connection Timeout'
       puts 'Connection timeout'
     end
   rescue Exception => err
     raise StudentVerificationError, 'Connection Timeout'
   end

   #raise if timeout
   Rails.cache.write("ext_verify_cookie", @@response.response['set-cookie'], :ttl=>25.minutes.to_i)
   parsed_response=Nokogiri.parse(@@response.body)

   if parsed_response.css('error').first.content == "false"
     return parsed_response.css('found').first.content == "true"
   else
     raise StudentVerificationError, parsed_response.css('errorString').first.content
   end
  end
end
