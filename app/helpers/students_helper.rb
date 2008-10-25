module StudentsHelper
  def selected_navigation
    if multiple_selected_students?
      index=selected_students_ids.index(current_student_id)
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
    check_box_tag("intervention_group_types[]",grp.id,false,:id=>dom_id(grp), :onclick=>"searchByIntervention()") + 
      label_tag(dom_id(grp), grp.title)

  end

  def active_intervention_select
    current_district.search_intervention_by.inject(''){|result, grp| result += intervention_group_checkbox(grp)}
  end

end
