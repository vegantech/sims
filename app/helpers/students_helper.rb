module StudentsHelper
  def selected_navigation
    if multiple_selected_students?
      index = selected_students_ids.index(current_student_id)
      ret = "Student #{index+1} of #{selected_students_ids.size} &nbsp;&nbsp; "

      unless index == 0
        ret += link_to('<<', student_url(selected_students_ids.first))
        ret += "&nbsp;&nbsp;"
        ret += link_to('Previous', student_url(selected_students_ids[index-1]))
        ret += "&nbsp;&nbsp;"
      end

      unless index == (selected_students_ids.size() -1)
        ret += link_to('Next', student_url(selected_students_ids[index+1]))
        ret += "&nbsp;&nbsp;"
        ret += link_to('>>', student_url(selected_students_ids.last))
      end
      content_tag :p, ret
    end
  end

  def intervention_group_checkbox(grp)
    '<div class="small_bump_right">' +
    check_box_tag("intervention_group_types[]",grp.id,false,:id=>dom_id(grp), :onclick=>"searchByIntervention()") + 
      label_tag(dom_id(grp), grp.title) +
    "</div>"
  end

  def active_intervention_select
    current_district.search_intervention_by.inject(''){|result, grp| result += intervention_group_checkbox(grp)}
  end

  def id_district_desc(obj)
    obj_text=obj.class.name.downcase
  "District identifier for this #{obj_text} (the #{obj_text}_id or primary_key in your SIS)"
  end

  def id_state_desc(obj)
    obj_text = obj.class.name.downcase
    "State identifier for this #{obj_text} (the id used by your state DPI)"
  end

  def id_country_desc(obj)
    obj_text = obj.class.name.downcase
    "National identifier for this #{obj_text} (the ID used by the Deptartment of Education)"
  end

  def extended_profile(student)
    if !student.new_record? && student.extended_profile?
      student.extended_profile
    end
  end

  def team_notes_count(student)
    "<span id='team_notes_count'>(#{student.comments.size})</span>"
  end

  def active_interventions_count(student)
    "<span id='active_interventions_count'>(#{student.interventions.active.size})</span>"
  end

  def inactive_interventions_count(student)
    "<span id='inactive_interventions_count'>(#{student.interventions.inactive.size})</span>"
  end
end
