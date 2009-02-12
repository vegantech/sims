require 'rubygems'
require 'hpricot'

state=State.find_by_abbrev("wi")
doc= open(File.join(File.dirname(__FILE__),"districts.aspx")) { |f| Hpricot(f) }
(doc/"table table table").each do |district_listing|
  name=(district_listing/'font').first.children.first.to_s
  lines=(district_listing/"tr td").to_s.split("<br />")
  leanum= lines[2].split(';').last.to_i
  web=(district_listing/"a").last.children.first.to_s
  puts name if web.nil?
  web="" if web.include?("@")
  email=(district_listing/"a").first.children.first.to_s


  abbrev=web.split("k12").first.split(".").last if web.include?"k12.wi.us"
  
  abbrev = web.split("org").first.split(".").last if  !abbrev  and web.include?(".org")
  abbrev=email.split("@").last.split(".").first if !abbrev

  abbrev = web.split("com").first.split(".").last if  !abbrev  and web.include?(".com")

  abbrev = "dmontessori" if name == "Downtown Montessori"
  abbrev= "dasdk12" if name == "Drummond Area"

  abbrev ="badger#{leanum}" if abbrev =="badger"
  abbrev ="seedsofhealth#{leanum}" if abbrev =="seedsofhealth"

  abbrev.gsub!(/-/,"") if abbrev

  if state.districts.find_by_state_dpi_num(leanum)
    puts name+ "is already in the system"
  else
    state.districts.create!(:state_dpi_num=>leanum, :name=>name, :abbrev=>abbrev)
  end




end


