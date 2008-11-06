class ProbeQuestionsController < ApplicationController
  # GET /probe_questions
  # GET /probe_questions.xml
  def index
    @probe_questions = ProbeQuestion.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @probe_questions }
    end
  end

  # GET /probe_questions/1
  # GET /probe_questions/1.xml
  def show
    @probe_question = ProbeQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @probe_question }
    end
  end

  # GET /probe_questions/new
  # GET /probe_questions/new.xml
  def new
    @probe_question = ProbeQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @probe_question }
    end
  end

  # GET /probe_questions/1/edit
  def edit
    @probe_question = ProbeQuestion.find(params[:id])
  end

  # POST /probe_questions
  # POST /probe_questions.xml
  def create
    @probe_question = ProbeQuestion.new(params[:probe_question])

    respond_to do |format|
      if @probe_question.save
        flash[:notice] = 'ProbeQuestion was successfully created.'
        format.html { redirect_to(@probe_question) }
        format.xml  { render :xml => @probe_question, :status => :created, :location => @probe_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @probe_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /probe_questions/1
  # PUT /probe_questions/1.xml
  def update
    @probe_question = ProbeQuestion.find(params[:id])

    respond_to do |format|
      if @probe_question.update_attributes(params[:probe_question])
        flash[:notice] = 'ProbeQuestion was successfully updated.'
        format.html { redirect_to(@probe_question) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @probe_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /probe_questions/1
  # DELETE /probe_questions/1.xml
  def destroy
    @probe_question = ProbeQuestion.find(params[:id])
    @probe_question.destroy

    respond_to do |format|
      format.html { redirect_to(probe_questions_url) }
      format.xml  { head :ok }
    end
  end
end
