class ChecklistBuilder::QuestionsController < ApplicationController
  before_filter :load_checklist_definition, :except => :suggestions

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
        format.html { render :action => "new" }
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
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  def destroy
    @question_definition = @checklist_definition.question_definitions.find(params[:id])
     if @question_definition.has_answers?
      flash[:notice]= "Question definition is in use, please copy the checklist instead"
    else
      flash[:notice] = ""
      @question_definition.destroy
    end

    respond_to do |format|
      format.html { redirect_to checklist_builder_checklist_url(@checklist_definition) }
      format.js
    end
  end

  def move
    @question_definition = @checklist_definition.question_definitions.find(params[:id])

    if params[:direction]
      @question_definition.move_higher if params[:direction] == "up"
      @question_definition.move_lower if params[:direction] == "down"
    end

    respond_to do |format|
      format.js
    end
  end

  protected
  def load_checklist_definition
    @checklist_definition = current_district.checklist_definitions.find(params[:checklist_id])
  end

end
