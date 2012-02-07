FactoryGirl.define do
  factory :checklist do |c|
    c.association :student
    c.association :teacher, :factory => :user
    c.association :tier
    c.association :checklist_definition
  end

  factory :checklist_definition do |c|
    c.directions "Please folow the directions"
    c.text "Text for Checklist"
  end

  factory :question_definition do |q|
    q.text  "Question"
  end

  factory :element_definition do |e|
    e.text  "Element"
    e.kind  'applicable'
  end

  factory :answer do |a|
    a.association :answer_definition
    a.text "Answer"
  end

  factory :answer_definition do |a|
    a.value 0
  end

  factory :basic_checklist_definition, :parent => :checklist_definition do |c|
    c.directions "Please folow the directions"
    c.text "2 questions, containing 1 of each element"
    c.active true
    c.after_create do |cd|
      FactoryGirl :basic_question_definition, :text => "Question 1", :checklist_definition => cd
      FactoryGirl  :basic_question_definition, :text => "Question 2", :checklist_definition => cd
    end
  end

  factory :basic_question_definition, :parent => :question_definition  do |q|
    q.text "Question with 1 of each element"
    q.after_create do |qd|
      ElementDefinition.kinds_of_elements.each {|kind, desc| FactoryGirl "#{kind}_element_definition",  :question_definition => qd}
    end
  end

  factory :scale_element_definition, :parent => :element_definition do |e|
    e.text "Scale Element"
    e.kind 'scale'
    e.after_create do |ed|
      0.upto(4) {|a| FactoryGirl :answer_definition, :text => "Answer #{a}", :value => a, :element_definition => ed }
    end
  end

  factory :applicable_element_definition, :parent => :element_definition do |e|
    #no text for this one
    e.kind 'applicable'
    e.after_create do |ed|
      FactoryGirl :answer_definition, :text => 'Not applicable',   :value => 0, :element_definition => ed
      FactoryGirl :answer_definition, :text =>  'Applicable',   :value => 1, :element_definition => ed
      FactoryGirl :answer_definition, :text => 'More notes',   :value => 1, :element_definition => ed
    end
  end

  factory :sa_element_definition, :parent => :element_definition do |e|
    e.text "Short Answer"
    e.kind 'sa'
    e.after_create do |ed|
      FactoryGirl :answer_definition,  :value => 0, :element_definition => ed
    end
  end

  factory :comment_element_definition, :parent => :element_definition do |e|
    e.text "Comment element"
    e.kind 'comment'
    e.after_create do |ed|
      FactoryGirl :answer_definition,  :value => 0, :element_definition => ed
    end
  end
end
