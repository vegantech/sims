module FlagsHelper
  # Since all helpers are loaded, I'll just group them by convenience
  def draft_consultations
    drafts = current_user.team_consultations.draft.find_all_by_student_id(current_student.id)
    drafts |= current_student.team_consultations.draft if current_student.principals.include?(current_user)
    drafts
  end


  def image_with_popup(image, popup)
    image_tag(image,"onmouseover" => "return overlib('#{popup}');",
      "onmouseout" => "return nd();") + " "
  end

  def status_display(student, changeable = false)
    str = intervention_status(student)
    str += current_flags(student, changeable)
    str += team_concerns(student)
    str += team_notes(student)
    str += ignore_flags(student)
    str += custom_flags(student)
    str.html_safe
  end

  def team_notes?(student)
    student.comments.present?
  end

  def team_notes(student)
    if team_notes?(student)
       image_with_popup('note.png',"#{pluralize student.comments.count, "team note"}")
    else
      ''.html_safe
    end
  end

  def team_concerns?(student = current_student)
    student.team_consultations_pending.present?
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
      popup="Custom Flags : #{flag_summary(student.custom_flags)}"
      image_with_popup("C.gif",popup)
    end || ""
  end

  def flag_summary(flags)
    flags.collect(&:summary).join(" ").gsub(/\n/,'')
  end

  def ignore_flags(student, changeable = false)
    unless changeable || student.ignore_flags.blank?
      popup = "Ignore Flags :  #{flag_summary(student.ignore_flags)}"
      image_with_popup("I.gif", popup)
    else
      s = student.ignore_flags.collect do |igflag|
        popup = "#{igflag.category.humanize} - #{igflag.reason}  by #{igflag.user} #{'on ' + igflag.created_at.to_s(:chatty) if igflag.created_at}"

        form_tag({:action => "unignore_flag", :id => igflag, :controller => "custom_flags"},
          {:class => "flag_button", :style => "display:inline", :remote => true}) {
          image_submit_tag(igflag.icon, "onmouseover" => "return overlib('#{popup}');", "onmouseout" => "return nd();") }
      end
      s.join(" ").html_safe
    end
  end

  def current_flags(student, changeable = false )
    student.current_flags.collect do |flagtype, flags|

      popup = "#{Flag::FLAGTYPES[flagtype][:humanize]} : #{flag_summary(flags)}"

      if changeable
        form_tag({:action => "ignore_flag", :category => flags.first.category, :controller => "custom_flags"},
          {:style => "display:inline", :remote => true}) {
          image_submit_tag(flags.first.icon, "onmouseover" => "return overlib('#{popup}');", "onmouseout" => "return nd();") }
      else
        image_with_popup(Flag::FLAGTYPES[flagtype][:icon], popup)
      end
    end.join(" ")
  end

  def flag_select
   content_tag( :div,  Flag::ORDERED_TYPE_KEYS.in_groups(2,false).collect{|group| group.inject(''){|result,flagtype| result += flag_checkbox(flagtype)}}.join("</div><div>").html_safe)
  end

  def flag_checkbox(flagtype)
    f = Flag::TYPES[flagtype.to_s]
    check_box_tag("flagged_intervention_types[]", flagtype, false, :id => "flag_#{flagtype}", :onclick => "searchByFlag()") +
    content_tag(:label, image_tag(f[:icon], :title=>f[:humanize]), {'for' => "flag_#{flagtype}"})
  end

  def display_flag_legend?(&block)
    flag_legend_controllers = ["students","flag_descriptions", "flag_categories"]
    if flag_legend_controllers.include?(controller.controller_name)
      cache ["flag_legend2",current_district] do
        @flag_description = FlagDescription.find_or_initialize_by_district_id(current_district.id)
        yield
      end
    end
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
