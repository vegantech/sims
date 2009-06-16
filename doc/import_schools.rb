#This is for reference in case I want to reimport the DPI school listing
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
  
def collection_of_things_I_want_to_remember
  #@district = mmsd_district
  mmsd_schools=@schools.select{|e| e.inner_text =~ /3269/}
  mmsd_schools.each {|o| h=parse_school(o);@district.schools.create!(:name => h[:name], :id_state=>h[:id_state])}    
 
end
