class Interventions::CommentsController < ApplicationController
  before_filter :load_intervention, except: :index

  def index
    @intervention=current_student.interventions.find(params[:intervention_id]) if current_student.present?
    @last_comment = params[:last_comment]
  end
  # GET /comments/new
  def new
    @intervention_comment = @intervention.comments.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def show
    @intervention_comment = @intervention.comments.find(params[:id])
    render layout: false
  end

  # GET /comments/1/edit
  def edit
    @intervention_comment = @intervention.comments.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /comments
  def create
    @intervention_comment = @intervention.comments.build(params[:intervention_comment].merge('user'=>current_user))

    respond_to do |format|
      if @intervention_comment.save
        flash[:notice] = 'InterventionComment was successfully created.'
        format.html { redirect_to(@intervention) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /comments/1
  def update
    @intervention_comment = @intervention.comments.find(params[:id])
    @intervention_comment.comment = params[:intervention_comment][:comment] unless params[:intervention_comment].blank?

    respond_to do |format|
      if @intervention_comment.update_attributes(params[:intervention_comment].merge('user'=>current_user))
        flash[:notice] = 'InterventionComment was successfully updated.'
        format.html {}
      else
        format.js   { render action: 'edit' }
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @intervention_comment = @intervention.comments.find(params[:id])
    @intervention_comment.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to(current_student) }
    end
  end

  protected
  def load_intervention
    if current_student.present?
      @intervention=current_student.interventions.find(params[:intervention_id]) if current_student.present?
    else
      false
    end
  end
end
