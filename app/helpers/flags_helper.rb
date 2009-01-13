module FlagsHelper
  # Since all helpers are loaded, I'll just group them by convenience
  #
  def image_with_popup(image,popup)
    image_tag(image,"onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();") + " "
  end

  

  def status_display(student, change = nil)
    str = intervention_status(student)
    str += current_flags(student,change)
    str += ignore_flags(student)
    str += custom_flags(student)
  end

  def custom_flags(student)
    if student.flags.custom.any?
      popup="C: Custom Flags- #{student.flags.custom.summary}"
      image_with_popup("C.gif",popup)
    end || ""
  end


  def ignore_flags(student, changable=false)
    if !changable && student.flags.ignore.any?
      popup = "I: Ignore Flags -  #{student.flags.ignore.summary}"
      image_with_popup("I.gif",popup)
    else
      s=student.flags.ignore.collect do |igflag|
        popup="#{igflag.category.humanize} - #{igflag.reason}  by #{igflag.user} #{'on ' + igflag.created_at.to_s(:chatty) if igflag.created_at}"
        form_remote_tag(:url=>{:action=> "unignore_flag", :id=>igflag,:controller=>"custom_flags"},:html=>{:class=>"flag_button", :style=>"display:inline"}) +
          image_submit_tag(igflag.icon,"onmouseover" => "return overlib('#{popup}');","onmouseout" => "return nd();") +
        "</form>"
      end
    s.join(" ")
    end
  end


  
  def current_flags(student, change = nil )
    student.flags.current.collect do |flagtype,flags|
        popup="#{Flag::FLAGTYPES[flagtype][:icon].split('.').first.upcase}: #{flags.collect(&:summary).join(" ")}"
      if change
        form_remote_tag(:url=>{:action=> "ignore_flag", :category=>flags.first.category,:controller=>"custom_flags"},:html=>{:style=>"display:inline"}) +
          image_submit_tag(flags.first.icon,"onmouseover" => "return overlib('#{popup}');","onmouseout" => "return nd();") +
        "</form>"
      else
        image_with_popup(Flag::FLAGTYPES[flagtype][:icon],popup)

      end
    end.join(" ")
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
      str << image_with_popup("green-dot.gif",popup)
    end
    
    if student.interventions.inactive.any?
      popup =  student.interventions.inactive.collect(&:title).join('<br />')
      str << image_with_popup("gray-dot.gif",popup)
    end
    str.join(" ")
  end
 
end
