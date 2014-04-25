module FlagsHelper
  # Since all helpers are loaded, I'll just group them by convenience
  def draft_consultations
    drafts = current_user.team_consultations.draft.find_all_by_student_id(current_student.id)
    drafts |= current_student.team_consultations.draft if current_student.principals.include?(current_user)
    drafts
  end


  def image_with_popup(image, popup)
    image_tag(image, :class => "popup", "data-help" => popup.html_safe) + " "
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
    student.comments.size > 0
  end

  def team_notes(student)
    if team_notes?(student)
       image_with_popup('note.png',"#{pluralize student.comments.size, "team note"}")
    else
      ''.html_safe
    end
  end

  def team_concerns?(student = current_student)
    student.team_consultations_pending.size > 0
  end

  def team_concerns(student)
    if team_concerns?(student)
      image_with_popup('comments.png', "Open Team Consultations")
    else
      ''
    end
  end

  def default_show_team_concerns?(student = current_student, user = current_user)
    current_district.show_team_consultations_if_pending? && student.team_consultations.pending_for_user(user).present?
  end


  def custom_flags(student)
    unless student.custom_flags.blank?
      popup = "Custom Flags : #{flag_summary(student.custom_flags)}"
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

        form_tag(igflag,
          {class: "flag_button", style: "display:inline", remote: true, method: "delete"}) {
          image_submit_tag(igflag.icon, :class => "popup", "data-help" => popup.html_safe) }
      end
      s.join(" ").html_safe
    end
  end

  def current_flags(student, changeable = false )
    student.current_flags.collect do |flagtype, flags|

      popup = "#{Flag::FLAGTYPES[flagtype][:humanize]} : #{flag_summary(flags)}"

      if changeable
        form_tag(new_ignore_flag_path(category: flags.first.category),
          {style: "display:inline", remote: true, method: :get}) {
          image_submit_tag(flags.first.icon, :class => "popup", "data-help" => popup.html_safe) }
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
    check_box_tag("flagged_intervention_types[]", flagtype, false, id: "flag_#{flagtype}", class: "flag_checkbox") +
    content_tag(:label, image_tag(f[:icon], title: f[:humanize]), {'for' => "flag_#{flagtype}"})
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
    [
      intervention_dot(student.active_interventions, "green-dot.gif"),
      intervention_dot(student.inactive_interventions, "gray-dot.gif")
    ].join(" ")
  end


  def intervention_dot(interventions, filename)
    popup =  interventions.collect{|i| h i.title}.join('<br />')
    image_with_popup(filename, popup) if popup.present?
  end
end
