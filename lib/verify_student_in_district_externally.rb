module VerifyStudentInDistrictExternally
  require 'net/https'
  require 'uri'
  require 'nokogiri'

  def self.verify(student,district)
    if true 
      verify_at_dpi(student,district)
    else
      raise "Unsupported"
    end

  end

#true return true
#false return false
#error throw exception

  def self.verify_at_dpi(student,district)
#   curl "https://uaapps.dpi.wi.gov/SIMS_Student_Location_Confirm/SIMS/nonsecure"
 #  -d wsn=9000000099 -d district=3456 -H "Accept: text/xml"


   uri = URI.parse("https://uaapps.dpi.wi.gov/SIMS_Student_Location_Confirm/SIMS/nonsecure")
   #uri = URI.parse("https://uaapps.dpi.wi.gov/SIMS_Student_Location_Confirm/SIMS/lookup")
   http=Net::HTTP.new(uri.host, uri.port)
   http.use_ssl=true
   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

   request = Net::HTTP::Post.new(uri.request_uri)
#   request.basic_auth[offband, offband]
   #   
   request.set_form_data({"district" => "#{district}", "wsn"=>"#{student}"})
   request["Accept"]="text/xml"
   #set timeout here
   response=http.request(request)
   #throw if timeout
   parsed_response=Nokogiri.parse(response.body)

   if parsed_response.css('error').first.content == "false"
     return parsed_response.css('found').first.content == "true"
   else
     #throw parsed_response.css('errorString').first.content
   end

   #timeout
   #check for error and error string
   #if error throw error string
   #return found




  end


end
