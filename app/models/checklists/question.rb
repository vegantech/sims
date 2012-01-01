class Checklists::Question
  def initialize(checklist, question_definition)
    @checklist = checklist
    @question_definition = question_definition
  end

  def checklist
    @checklist
  end

  def definition
    @question_definition
  end

  def to_s
    @question_definition.title
  end

  def text
    @question_definition.text
  end

  def position
    @question_definition.position
  end

  def max_count
    elements.select(&:inside_table?).collect(&:answer_count).max
  end

  def elements
    #I want these ordered by position, but with relevant types first and sa's at the end
    @elements ||= @question_definition.element_definitions.collect{|ed| Checklists::Element.new(self,ed)}
  end
end
