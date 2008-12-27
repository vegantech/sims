module FlagsHelper
  # Since all helpers are loaded, I'll just group them by convenience

  def displayflag(image,popup,flagtype, student)
    raise "Where is displayflag called?"
    image_tag(image,"onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();") + " "
  end

  def status_display(student, change = nil)
    str = intervention_status(student)
    str += current_flags(student)
    str += ignore_flags(student,change)
    str += custom_flags(student,change)
  end

  def custom_flags(student,change=nil)
    if change.nil? && student.flags.custom.any?
      popup="C: Custom Flags- #{student.flags.custom.summary}"
      image_tag("C.gif",
      "onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();")
    else 
      ""
    end

  end



  def ignore_flags(student, changable=false)
    if !changable && student.flags.ignore.any?
      popup = "I: Ignore Flags -  #{student.flags.ignore.summary}"
      image_tag("I.gif",
      "onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();")
    else
      s=student.flags.ignore.collect do |igflag|
       popup="#{igflag.category.humanize} - #{igflag.reason}  by #{igflag.user} #{'on ' + igflag.created_at.to_s(:chatty) if igflag.created_at}"
       image_tag(igflag.icon, "onmouseover" => "return overlib('#{popup}');",
                 "onmouseout" => "return nd();")
      end
    s.join(" ")
    end
  end



=begin
def displayflag(change,image,popup,flagtype, student)
  raise "OR ME"
  if change
    form_remote_tag(:url=>{:action=> "ignore_flag", :id=>student,:controller=>"student_flags", :flagtype=>flagtype},:html=>{:style=>"display:inline"}) +
    image_submit_tag(image,"onmouseover" => "return overlib('#{popup}');",
    "onmouseout" => "return nd();") +
    "</form>"
  else
    image_tag(image,"onmouseover" => "return overlib('#{popup}');",
    "onmouseout" => "return nd();") + " "
  end
end 


def ignoreflag(image,popup,flag,change=true)
if change
form_remote_tag(:url=>{:action=> "unignore_flag", :id=>flag,:controller=>"student_flags"},:html=>{:style=>"display:inline"}) +
image_submit_tag(image,"onmouseover" => "return overlib('#{popup}');",
"onmouseOut" => "return nd();") +
"</form>"
else
image_tag(image,"onmouseover" => "return overlib('#{popup}');",
"onmouseout" => "return nd();")
end
                                                                                                                        
=end
                                                                                                                    

  
  def current_flags(student)
    s=student.flags.current.collect do |flagtype,flags|
      popup="#{Flag::FLAGTYPES[flagtype][:icon].split('.').first.upcase}: #{flags.collect(&:summary).join(" ")}"
      image_tag(Flag::FLAGTYPES[flagtype][:icon], "onmouseover" => "return overlib('#{popup}');",
                 "onmouseout" => "return nd();")

    end
    s.join(" ")
  end





  def flag_select
    Flag::ORDERED_TYPE_KEYS.inject(''){|result,flagtype| result += flag_checkbox(flagtype)}
  end

  def flag_checkbox(flagtype)
    f = Flag::TYPES[flagtype.to_s]
    check_box_tag("flagged_intervention_types[]", flagtype, false,:id=>"flag_#{flagtype}", :onclick=>"searchByFlag()") +
    content_tag(:label, image_tag(f[:icon], :title=>f[:humanize]), {'for' => "flag_#{flagtype}"})
  end

  def display_flag_legend?(&block)
    yield if controller.controller_name=="students"
  end

  def intervention_status(student)
    str = []
    if student.interventions.active.any?
      popup =  student.interventions.active.collect(&:title).join('<br />')
      str << image_tag("green-dot.gif",
        "onmouseover" => "return overlib('#{popup}');",
        "onmouseout" => "return nd();")
    end
    
    if student.interventions.inactive.any?
      popup =  student.interventions.inactive.collect(&:title).join('<br />')
      str << image_tag("gray-dot.gif",
        "onmouseover" => "return overlib('#{popup}');",
        "onmouseout" => "return nd();")
    end
    str.join(" ")
  end
 
end
