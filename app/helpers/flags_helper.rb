module FlagsHelper
  # Since all helpers are loaded, I'll just group them by convenience

  def displayflag(image,popup,flagtype, student)
    image_tag(image,"onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();") + " "
  end

  def status_display(student, change = nil)
    str = intervention_status(student)
    str += current_flags(student)
    str += custom_flags(student,change)
  end

  def current_flags(student)
    s=student.flags.current.collect do |flagtype,flags|
      popup="#{Flag::FLAGTYPES[flagtype][:icon].split('.').first.upcase}: #{flags.collect(&:summary).join(" ")}"
    end
    s.join(" ")
  end

  def custom_flags(student,change=nil)
    if change.nil? && student.flags.any?
      popup="C: Custom Flags- #{student.flags.custom_summary}"
      image_tag("C.gif",
      "onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();")
    else 
      ""
    end

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
    str = ''
    if student.interventions.active.any?
      popup =  student.interventions.active.collect(&:title).join('<br />')
      str += image_tag("green-dot.gif",
        "onmouseover" => "return overlib('#{popup}');",
        "onmouseout" => "return nd();") + " "
    end
    
    if student.interventions.inactive.any?
      popup =  student.interventions.inactive.collect(&:title).join('<br />')
      str += image_tag("gray-dot.gif",
        "onmouseover" => "return overlib('#{popup}');",
        "onmouseout" => "return nd();") + " "
    end
  str
  end
 
end
