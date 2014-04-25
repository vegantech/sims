module ChecklistsHelper
  def mmsd_eligibility_criteria menu = false
    if current_district.try(:madison?)
    elig_crit = ["Autism.doc", "Cognitive_Disability.doc", "Emotional_Behavioral_Disability.doc",
               "Hearing_Impairment.doc", "Other_Health_Impaired.doc", "Specific_Learning_Disability_reeval.doc", "Specific_Learning_Disability-Initial.doc",
               "Speech_and_Language_Impairment.doc","Visual_Impairment.doc"]
       f = elig_crit.collect do |elig_file|
        content_tag(:li,(link_to_with_icon elig_file,"/system/#{elig_file}" , suffix = " criteria"))
       end

     if menu
       plus_minus_li("Special Ed Eligibility Criteria" ,f.join("").html_safe)
    else
       content_tag(:ul, f.join.html_safe)
     end
   else
     ""
   end

  end
  def previous_answers(checklist, answer_definition, &block)
    return if checklist.student.blank?
    if block_given?
      if (answers = checklist.previous_answers_for(answer_definition)).any?
        concat "<div style=\"color:gray\">Previous Answers:</div>".html_safe
        answers.each do |answer|
          concat(capture(answer, &block))
        end
      end
    end
  end

  def radio_button_group(checklist, element_definition, &block)
    if block_given?
      #      answer = checklist.previous_answer_for(element_definition)
      element_definition.answer_definitions.each do |answer_definition|
        #        if answer and answer.answer_definition_id == answer_definition.answer_definition_id
        checked = checklist.answers.collect(&:answer_definition_id).include?(answer_definition.id)
        concat(capture(answer_definition,checked,&block))
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
    correct_question?(checklist,question_definition) or
    checklist.score_results[question_definition][element_definition].blank?
  end

  def incorrect_answer_highlight
    'class="incorrectAnswer"'
  end

  def autoset_message(answer_definition)
    ('&nbsp;' * 5 + content_tag( :b,"This answer will be applied to the other elements") + '<br />').html_safe if answer_definition.autoset_others?
  end

  def recommendation_buttons(form)
  b = Recommendation::RECOMMENDATION.sort
  b[1],b[2] = b[2],b[1]   #No progress at current level should be the second element
   a = b.collect do |k,v|
     opts = {}
     next  if  v[:show_elig] && !show_referral_option?
     opts = {class: 'show_elig'} if v[:show_elig]
     form.radio_button(:recommendation, k,opts) +
       form.label("recommendation_#{k}",v[:text], radio_button_value: k) + (v[:require_other] ? recommendation_other_extras(form) : "") if form.object.show_button?(k)
   end
   a.compact.join("<br />\n").html_safe

   #
  end

  def recommendation_other_extras(form)
    form.text_field(:other,size: "90", class: 'spell_check')   +
    form.check_box(:advance_tier) + form.label(:advance_tier) + ' ' +
    help_popup("Choose to advance the tier or not, only applies if you are choosing 'Other'")
  end

  def markdown_note
      link_to "You can use markdown","http://daringfireball.net/projects/markdown/",target: "_blank"
  end

  def markdown_with_span(text)
    content_tag :span, markdown(text.to_s.gsub(/\r\n\*/,"\n\n*")),class: 'markdown'
  end

  def markdown(t)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @markdown.render(h(t)).html_safe
  end

  def autoset(answer_definition)
    if answer_definition.autoset_others?
      "autoset answer#{answer_definition.position}"
    else
      "answer#{answer_definition.position}"
    end
  end
end
