class ChecklistBuilder::ElementsController < ChecklistBuilder::Base
  before_filter :load_checklist_definition, :load_question_definition

  def index
    @element_definitions = @question_definition.element_definitions

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    show_or_edit
  end

  def new
    @element_definition = @question_definition.element_definitions.build

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    show_or_edit
  end

  def create
    @element_definition = @question_definition.element_definitions.build(params[:element_definition])
    save_or_update "new", "created"
  end

  def update
    @element_definition = @question_definition.element_definitions.find(params[:id])
    @element_definition.attributes= params[:element_definition]
    save_or_update "edit", "updated"
  end

  def destroy
    @element_definition = @question_definition.element_definitions.find(params[:id])
    check_for_content(@element_definition)

    respond_to do |format|
      format.html { redirect_to checklist_definition_url(@checklist_definition) }
      format.js
    end
  end

  def move
    @element_definition = @question_definition.element_definitions.find(params[:id])
    super
  end

  protected
  def save_or_update redirect_action, result_verb
    respond_to do |format|
      if @element_definition.save
        @element_definition.answer_definitions.create!(value: 0) unless @element_definition.answer_definitions.count >0
        flash[:notice] = "Element Definition was successfully #{result_verb}"
        format.html { redirect_to checklist_definition_question_definition_element_definition_url(@checklist_definition, @question_definition, @element_definition) }
        format.js
      else
        format.html { render action: redirect_action }
        format.js
      end
    end
  end

  def my_object
    @element_definition
  end

  def show_or_edit
    @element_definition = @question_definition.element_definitions.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
