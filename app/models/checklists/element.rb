class Checklists::Element
  include Comparable
  def initialize(question, element_definition)
    @question = question
    @element_definition = element_definition
  end

  def checklist
    @question.checklist
  end

  def position
    @element_definition.position
  end

  def kind
    @element_definition.kind.to_sym
  end

  def text
    @element_definition.text
  end

  def applicable?
    kind == :applicable
  end

  def inside_table?
    !applicable?
  end

  def sa?
    kind == :sa
  end

  def answers
    @answers ||= @element_definition.answer_definitions.collect{|ad| Checklists::Answer.new(self,ad)}
  end

  def answer_count
    answers.size
  end

  def max_count
    @question.max_count
  end

  def <=>(right)
    #I might not need this
    if kind == :applicable && right.kind == :applicable
      position <=> right.position
    elsif kind == :applicable && right.kind !=:applicable
       -1
    elsif kind != :applicable && right.kind == :applicable
       1
    elsif kind == :sa && right.kind == :sa
       position <=> right.position
    elsif kind == :sa && right.kind !=:sa
       1
    elsif kind != :sa && right.kind == :sa
      -1
    else
      position <=> right.position
    end
  end

  def id
    @element_definition.id
  end

end
