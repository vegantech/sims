module CustomFlagsHelper
  # These will go in system flags when it is created

  def displayflag(image,popup,flagtype, student)
    image_tag(image,"onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();") + " "
  end

  def status_display(student, change = nil)
    str = ''

    student.flags.current.each do |flagtype,flags|
      popup="#{Flag::FLAGTYPES[flagtype][:icon].split('.').first.upcase}: #{flags.collect(&:summary).join(" ")}"
      str += displayflag(Flag::FLAGTYPES[flagtype][:icon],popup, flagtype, student)      
    end

    if change.nil? && student.flags.any?
      popup="C: Custom Flags- #{student.flags.custom_summary}"
      str += image_tag("C.gif",
      "onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();")
    end

    str
  end

  def flag_select
    Flag::ORDERED_TYPE_KEYS.inject(''){|result,flagtype| result += flag_checkbox(flagtype)}
  end

  def flag_checkbox(flagtype)
    f = Flag::TYPES[flagtype.to_s]
    check_box_tag("flagged_intervention_types[]", flagtype, false,:id=>"flag_#{flagtype}", :onclick=>"searchByFlag()") +
    content_tag(:label, image_tag(f[:icon], :title=>f[:humanize]), {'for' => "flag_#{flagtype}"})
  end

end