
def import_schools
require 'nokogiri'
require 'open-uri'

#doc= Nokogiri::HTML(open('http://dpi.wi.gov/pubschools.aspx'))
doc= Nokogiri::HTML(open('/home/shawn/git/sims-open/tmp/pubschools.aspx'))

@schools = (doc/"table#dgResults table>tr>td")
end

def parse_school(sch_section)
  hsh = {}
  hsh[:name] = (sch_section/"strong font").inner_text
  hsh[:district_dpi_num] = sch_section.children[9].inner_text.reverse.to_i.to_s.reverse.to_i
  hsh[:id_state] = sch_section.children[15].inner_text.reverse.to_i.to_s.reverse.to_i
  hsh 
end
  
  
