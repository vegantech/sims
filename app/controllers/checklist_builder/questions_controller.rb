class ChecklistBuilder::QuestionsController < ChecklistBuilder::Base
  before_filter :load_checklist_definition

  def index
    @question_definitions = @checklist_definition.question_definitions

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @question_definition = QuestionDefinition.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @question_definition = QuestionDefinition.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @question_definition = QuestionDefinition.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @question_definition = @checklist_definition.question_definitions.build(params[:question_definition])

    respond_to do |format|
      if @question_definition.save
        flash[:notice] = 'Question Definition was successfully created.'
        format.html { redirect_to checklist_builder_question_url(@checklist_definition, @question_definition) }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  def update
    @question_definition = QuestionDefinition.find(params[:id])
    @question_definition.attributes = params[:question_definition]


    respond_to do |format|
      if @question_definition.save
        flash[:notice] = 'Question Definition was successfully updated.'
        format.html { redirect_to checklist_builder_question_url(@checklist_definition, @question_definition) }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  def destroy
    @question_definition = @checklist_definition.question_definitions.find(params[:id])
    destroy_unless_content(@question_definition)

    respond_to do |format|
      format.html { redirect_to checklist_builder_checklist_url(@checklist_definition) }
      format.js
    end
  end

  def move
    @question_definition = @checklist_definition.question_definitions.find(params[:id])
    super
  end

  protected
  def my_object
    @question_definition
  end
end
