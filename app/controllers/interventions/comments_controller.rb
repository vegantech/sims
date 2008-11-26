class Interventions::CommentsController < ApplicationController
  before_filter :load_intervention
  # GET /intervention_comments
  # GET /intervention_comments.xml
  def index
    @intervention_comments = InterventionComment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @intervention_comments }
    end
  end

  # GET /intervention_comments/new
  # GET /intervention_comments/new.xml
  def new
    @intervention_comment = InterventionComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intervention_comment }
    end
  end

  # GET /intervention_comments/1/edit
  def edit
    @intervention_comment = InterventionComment.find(params[:id])
  end

  # POST /intervention_comments
  # POST /intervention_comments.xml
  def create
    @intervention_comment = InterventionComment.new(params[:intervention_comment])

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

  # PUT /intervention_comments/1
  # PUT /intervention_comments/1.xml
  def update
    @intervention_comment = InterventionComment.find(params[:id])

    respond_to do |format|
      if @intervention_comment.update_attributes(params[:intervention_comment])
        flash[:notice] = 'InterventionComment was successfully updated.'
        format.html { redirect_to(@intervention) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervention_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /intervention_comments/1
  # DELETE /intervention_comments/1.xml
  def destroy
    @intervention_comment = InterventionComment.find(params[:id])
    @intervention_comment.destroy

    respond_to do |format|
      format.html { redirect_to(@intervention) }
      format.xml  { head :ok }
    end
  end

protected
  def load_intervention
    @intervention=current_student.interventions.find(params[:intervention_id])
  end
end
