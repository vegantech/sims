class ChecklistBuilder::ElementsController < ApplicationController
  include SpellCheck
  before_filter :load_checklist_definition, :load_question_definition, :except => :suggestions

  def index
    @element_definitions = @question_definition.element_definitions

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @element_definition = @question_definition.element_definitions.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @element_definition = @question_definition.element_definitions.build

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @element_definition = @question_definition.element_definitions.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @element_definition = @question_definition.element_definitions.build(params[:element_definition])
    spellcheck [@element_definition.text].join(" ") and render :action => :new and return unless params[:spellcheck].blank? 

    respond_to do |format|
      if @element_definition.save

        @element_definition.answer_definitions.create!(:value=>0) unless @element_definition.answer_definitions.count >0
        flash[:notice] = 'Element Definition was successfully created.'
        format.html { redirect_to checklist_definition_question_definition_element_definition_url(@checklist_definition, @question_definition, @element_definition) }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  def update
    @element_definition = @question_definition.element_definitions.find(params[:id])

    a = request.xhr? ? :spell_fail : :edit
    spellcheck [@element_definition.text].join(" ") and render :action => a and return unless params[:spellcheck].blank? 

    respond_to do |format|
      if @element_definition.update_attributes(params[:element_definition])
        @element_definition.answer_definitions.create!(:value=>0) unless @element_definition.answer_definitions.count >0
        flash[:notice] = 'Element Definition was successfully updated.'
        format.html { redirect_to checklist_definition_question_definition_element_definition_url(@checklist_definition, @question_definition, @element_definition) }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  def destroy
    @element_definition = @question_definition.element_definitions.find(params[:id])
    @element_definition.destroy

    respond_to do |format|
      format.html { redirect_to checklist_definition_url(@checklist_definition) }
      format.js
    end
  end

  def move
    @element_definition = @question_definition.element_definitions.find(params[:id])

    if params[:direction]
      @element_definition.move_higher if params[:direction] == "up"
      @element_definition.move_lower if params[:direction] == "down"
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

  def show_options
    @checklist_definition_options = true
  end
end
