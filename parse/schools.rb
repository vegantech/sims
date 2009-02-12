require 'rubygems'
require 'hpricot'

state=State.find_by_abbrev("wi")
doc= open(File.join(File.dirname(__FILE__),"pubschools.aspx")) { |f| Hpricot(f) }
(doc/"table table table").each do |school_listing|

  name=(school_listing/'font').first.children.first.to_s

  lines=(school_listing/"tr td").to_s.split("<br />")
  leanum= lines[3].split(';').last.to_i
  district=state.districts.find_by_state_dpi_num(leanum)

  if district.schools.find_by_name(name)
    puts name+ "is already in the system"
  else
    district.schools.create(:name=>name)
  end




end


