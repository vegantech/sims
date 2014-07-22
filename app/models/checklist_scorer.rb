class ChecklistScorer
  def initialize(checklist)
    @checklist=checklist
    @inapplicable_questions = []
    @score_results=Hash.new{|h,k| h[k]={}}
  end

  delegate :checklist_definition_cache, :from_tier, :answers, :element_definitions_for_answers, to: :checklist

  def score
    # all 1-8 must be answered, all 9 must have some content common to all tiers
    checklist_definition_cache.element_definitions.each{ |e| score_element(e) }
    tier_check
    remove_inapplicable_questions
    @score_results
  end

  private
  attr_reader :checklist

  def score_element(element)
    if element.kind=="scale" and !element_definitions_for_answers.include?(element) then
      @score_results[element.question_definition][element] = "A value must be picked"
    elsif element.kind=="sa" and !element_definitions_for_answers.include?(element) then
      @score_results[element.question_definition][element]= "Text must be entered"
    elsif element.kind == "applicable"
      ad=element.answer_definitions.find_by_value(0).id
      @score_results[element.question_definition][element] = "A value must be picked" if !element_definitions_for_answers.include?(element)
      @inapplicable_questions << element.question_definition  if answers.collect(&:answer_definition_id).include?(ad)
    end
  end

  def tier_check
    case from_tier
    when 0,1
      nil
    when 2,3
      # All question 9 completed (done above),  Questions 1-8 needs an answer of [2,3] or better
      answers.each do |answer|
        @score_results[answer.answer_definition.element_definition.question_definition][answer.answer_definition.element_definition] =
          "Need to score #{from_tier} or better." if answer.answer_definition.value <"#{from_tier}" and answer.answer_definition.element_definition.kind=="scale"
      end # do
    end # case
  end

  def remove_inapplicable_questions
    @inapplicable_questions.each do |iq|
      @score_results.delete(iq)
    end
  end
end

