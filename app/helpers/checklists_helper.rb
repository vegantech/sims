module ChecklistsHelper
  def previous_answers(checklist, answer_definition, &block)
    return if checklist.student.blank?
    if block_given?
      if (answers = checklist.previous_answers_for(answer_definition)).any?
        concat "<div style=\"color:gray\">Previous Answers:</div>", block.binding
        answers.each do |answer|
          concat(capture(answer, &block),block.binding)
        end
      end
    end
  end

  def radio_button_group(checklist, element_definition, &block)
    if block_given?
      #      answer = checklist.previous_answer_for(element_definition)
      element_definition.answer_definitions.each do |answer_definition|
        #        if answer and answer.answer_definition_id == answer_definition.answer_definition_id
        checked= checklist.answers.collect(&:answer_definition_id).include?(answer_definition.id)
        concat(capture(answer_definition,checked,&block),block.binding)
      end
    end
  end

  def highlight_if_wrong_question(checklist, question_definition)
    incorrect_answer_highlight unless  correct_question?(checklist,question_definition)
  end

  def correct_question?(checklist, question_definition)
    checklist.score_results.blank?  or checklist.score_results[question_definition].blank?
  end

  def highlight_if_wrong_element(checklist,question_definition,element_definition)
    incorrect_answer_highlight  unless  correct_element?(checklist,question_definition,element_definition)
  end

  def reason_if_wrong_element(checklist,question_definition,element_definition)
    unless correct_element?(checklist,question_definition,element_definition)
      " --- #{checklist.score_results[question_definition][element_definition]}"

    else
      ""
    end
  end


  def correct_element?(checklist,question_definition,element_definition)
    checklist.score_results.blank? or checklist.score_results[question_definition].blank? or
    checklist.score_results[question_definition][element_definition].blank?
  end

  def incorrect_answer_highlight
    'class="incorrectAnswer"'
  end

  def autoset_onclick(question_definition, answer_definition)
    @autoset_others_hash ||= {}
    onclick = {}
    unless @autoset_others_hash[[question_definition,answer_definition.value]] 
      if answer_definition.autoset_others?
        st=[]
        question_definition.element_definitions.each do |ed|
          
          answer = ed.answer_definitions.find_by_autoset_others_and_value(true,answer_definition.value)
          st << ('document.checklist_form.elements["element_definition[' +"#{ed.id}"+']"][' +"#{-1 + answer.position }" +'].checked=true') unless answer.blank?
      end
        st=st.join(";")
        @autoset_others_hash[[question_definition,answer_definition.value]] = st
    end
      d=@autoset_others_hash[[question_definition,answer_definition.value]] 
      
      onclick = {:onclick=>d} 
    end
    onclick
 end
 
 def autoset_message(answer_definition)
   '&nbsp;'* 5 + content_tag( :b,"This answer will be applied to the other elements") + '<br />' if answer_definition.autoset_others? 
 end

end
