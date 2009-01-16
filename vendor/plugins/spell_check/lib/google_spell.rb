#Ruby interface to google toolbar spell,  taken from:
#http://oregonstate.edu/~reeset/blog/groups/programming/ruby/
require 'net/https'
require 'uri'
require 'rexml/document'

class GoogleSpell
  def self.GetWords(phrase)
    results = []
    x = 0
    i = 0

    phrase = phrase.downcase
    phrase = phrase.gsub("&", "&amp;")
    phrase = phrase.gsub("<", "&lt;")
    phrase = phrase.gsub(">", "&gt;")
    word_frag = phrase.split(" ")
    word_frag.each do |lookup|
      words = '<spellrequest textalreadyclipped="0" ignoredups="1" ignoredigits="1" ignoreallcaps="0"><text>' + lookup + '</text></spellrequest>'
      gword = Hash.new()
      gword["original"] = lookup;
      gword["data"] = ""
      http = Net::HTTP.new('www.google.com', 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response =  http.start {|net|
        net.request_post("/tbproxy/spell?lang=en", words) {|response|
          doc = REXML::Document.new response.body
          nodelist = doc.elements.to_a("//c")
          nodelist.each do |item|
            if !item.text.nil? && item.text.downcase != gword["original"]
              gword["data"] = item.text.downcase
            else
              gword["data"] = ""
            end
          end
        }
      }
      results << gword
    end
    return results
  end
end
