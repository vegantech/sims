class ChecklistBuilder::AnswersController < ApplicationController
  before_filter :load_checklist_definition, :load_question_definition, :load_element_definition, :except => :suggestions

  def index
    @answer_definitions = @element_definition.answer_definitions

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @answer_definition = AnswerDefinition.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @answer_definition = AnswerDefinition.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @answer_definition = AnswerDefinition.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @answer_definition = @element_definition.answer_definitions.build(params[:answer_definition])

    respond_to do |format|
      if @answer_definition.save
        flash[:notice] = 'Answer Definition was successfully created.'
        format.html { redirect_to checklist_builder_answer_url(@checklist_definition, @question_definition, @element_definition, @answer_definition) }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  def update
    @answer_definition = AnswerDefinition.find(params[:id])
    @answer_definition.attributes = params[:answer_definition]

    respond_to do |format|
      if @answer_definition.save
        flash[:notice] = 'Answer Definition was successfully updated.'
        format.html { redirect_to checklist_builder_answer_url(@checklist_definition, @question_definition, @element_definition, @answer_definition) }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  def destroy
    @answer_definition = AnswerDefinition.find(params[:id])
    if @answer_definition.sibling_definitions.count >1

      if @answer_definition.has_answers?
        flash[:notice]= "Answer definition is in use, please copy the checklist instead"
      else
        flash[:notice] = ""
        @answer_definition.destroy
      end
    else
      flash[:notice]= 'Every Element requires at least one answer definition'
    end

    respond_to do |format|
      format.html { redirect_to checklist_builder_checklist_url(@checklist_definition) }
      format.js
    end
  end

  def move
    @answer_definition = AnswerDefinition.find(params[:id])

    if params[:direction]
      @answer_definition.move_higher if params[:direction] == "up"
      @answer_definition.move_lower if params[:direction] == "down"
    end

    respond_to do |format|
      format.js
    end
  end

  protected
  def load_checklist_definition
    @checklist_definition = current_district.checklist_definitions.find(params[:checklist_id])
  end

  def load_question_definition
    @question_definition = @checklist_definition.question_definitions.find(params[:question_id])
  end

  def load_element_definition
    @element_definition = @question_definition.element_definitions.find(params[:element_id])
  end

  private
  def jquery?
    false
  end
end
