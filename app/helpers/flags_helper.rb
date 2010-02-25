module FlagsHelper
  # Since all helpers are loaded, I'll just group them by convenience

  def image_with_popup(image, popup)
    image_tag(image,"onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();") + " "
  end

  def status_display(student, changeable = false)
    str = intervention_status(student)
    str += current_flags(student, changeable)
    str += team_concerns(student)
    str += ignore_flags(student)
    str += custom_flags(student)
  end

  def team_concerns?(student = current_student)
    student.team_consultations.none?(&:complete) && student.team_consultations.present?
  end
  def team_concerns(student)
    if team_concerns?(student)
      image_tag('comments.png', :alt=>'Team Consultations')
    else
      ''
    end
  end
  

  def custom_flags(student)
    unless student.custom_flags.blank?
      popup="C: Custom Flags- #{flag_summary(student.custom_flags)}"
      image_with_popup("C.gif",popup)
    end || ""
  end

  def flag_summary(flags)
    flags.collect(&:summary).join(" ")
  end

  def ignore_flags(student, changeable = false)
    unless changeable || student.ignore_flags.blank?
      popup = "I: Ignore Flags -  #{flag_summary(student.ignore_flags)}"
      image_with_popup("I.gif", popup)
    else
      s = student.ignore_flags.collect do |igflag|
        popup = "#{igflag.category.humanize} - #{igflag.reason}  by #{igflag.user} #{'on ' + igflag.created_at.to_s(:chatty) if igflag.created_at}"

        form_remote_tag(:url => {:action => "unignore_flag", :id => igflag, :controller => "custom_flags"},
          :html => {:class => "flag_button", :style => "display:inline"}) +
          image_submit_tag(igflag.icon, "onmouseover" => "return overlib('#{popup}');", "onmouseout" => "return nd();") +
          "</form>"
      end
      s.join(" ")
    end
  end

  def current_flags(student, changeable = false )
    student.current_flags.collect do |flagtype, flags|
      @flagcount ||= Hash.new(0)
      @flagcount[flagtype] +=1

      popup = "#{Flag::FLAGTYPES[flagtype][:icon].split('.').first.upcase}: #{flag_summary(flags)}"

      if changeable
        form_remote_tag(:url => {:action => "ignore_flag", :category => flags.first.category, :controller => "custom_flags"},
          :html => {:style => "display:inline"}) +
          image_submit_tag(flags.first.icon, "onmouseover" => "return overlib('#{popup}');", "onmouseout" => "return nd();") +
          "</form>"
      else
        image_with_popup(Flag::FLAGTYPES[flagtype][:icon], popup)
      end
    end.join(" ")
  end

  def flag_select
    Flag::ORDERED_TYPE_KEYS.inject(''){|result,flagtype| result += flag_checkbox(flagtype)}
  end

  def flag_checkbox(flagtype)
    f = Flag::TYPES[flagtype.to_s]
    check_box_tag("flagged_intervention_types[]", flagtype, false, :id => "flag_#{flagtype}", :onclick => "searchByFlag()") +
    content_tag(:label, image_tag(f[:icon], :title=>f[:humanize]), {'for' => "flag_#{flagtype}"})
  end

  def display_flag_legend?(&block)
    flag_legend_controllers = ["students","flag_descriptions", "flag_categories"]
    @flag_description = FlagDescription.find_or_initialize_by_district_id(current_district.id) and yield if flag_legend_controllers.include? controller.controller_name
  end

  def intervention_status(student)
    str = []

    ai = student.active_interventions
    unless ai.blank?
      popup =  ai.collect(&:title).join('<br />')
      str << image_with_popup("green-dot.gif",popup)
    end

    ii = student.inactive_interventions
    unless ii.blank?
      popup =  ii.collect(&:title).join('<br />')
      str << image_with_popup("gray-dot.gif",popup)
    end
    str.join(" ")
  end
end
