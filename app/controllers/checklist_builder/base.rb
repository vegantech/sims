class ChecklistBuilder::Base < ApplicationController
  def move
    if params[:direction]
      my_object.move_higher if params[:direction] == "up"
      my_object.move_lower if params[:direction] == "down"
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

  def destroy_unless_content(object)
    if object.has_answers?
      flash[:notice]= "#{human_class_name(object)} is in use, please copy the checklist instead"
    else
      flash[:notice] = ""
      object.destroy
    end
  end

  def human_class_name(object)
    object.class.name.underscore.humanize
  end
end
