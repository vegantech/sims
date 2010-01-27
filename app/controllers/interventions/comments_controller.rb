class Interventions::CommentsController < ApplicationController
  before_filter :load_intervention
  include SpellCheck
  # GET /comments/new
  # GET /comments/new.xml
  def new
    @intervention_comment = @intervention.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intervention_comment }
    end
  end

  def show
    @intervention_comment = @intervention.comments.find(params[:id])
    render :layout => false
  end

  # GET /comments/1/edit
  def edit
    @intervention_comment = @intervention.comments.find(params[:id])
    respond_to do |format|
      format.html
    end

  end

  # POST /comments
  # POST /comments.xml
  def create
    @intervention_comment = @intervention.comments.build(params[:intervention_comment].merge('user'=>current_user))
    spellcheck @intervention_comment.comment and render :action=>:new and return unless params[:spellcheck].blank?
     

    respond_to do |format|
      if @intervention_comment.save
        flash[:notice] = 'InterventionComment was successfully created.'
        format.html { redirect_to(@intervention) }
        format.xml  { render :xml => @intervention_comment, :status => :created, :location => @intervention_comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervention_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @intervention_comment = @intervention.comments.find(params[:id])
    @intervention_comment.comment = params[:intervention_comment][:comment] unless params[:intervention_comment].blank?
  

    spellcheck @intervention_comment.comment and render :action=>:edit and return unless params[:spellcheck].blank?
    respond_to do |format|
      if @intervention_comment.update_attributes(params[:intervention_comment].merge('user'=>current_user))
        flash[:notice] = 'InterventionComment was successfully updated.'
        format.html {}
        format.xml  { head :ok }
      else
        format.js   { render :action => 'edit' }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervention_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @intervention_comment = @intervention.comments.find(params[:id])
    @intervention_comment.destroy 

    respond_to do |format|
      format.js
      format.html { redirect_to(current_student) }
      format.xml  { head :ok }
    end
  end

protected
  def load_intervention
    if current_student
      @intervention=current_student.interventions.find(params[:intervention_id]) if current_student.present?
    else
      false
    end
  end
end
