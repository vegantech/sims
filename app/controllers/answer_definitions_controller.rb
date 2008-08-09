class AnswerDefinitionsController < ApplicationController
  # GET /answer_definitions
  # GET /answer_definitions.xml
  def index
    @answer_definitions = AnswerDefinition.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @answer_definitions }
    end
  end

  # GET /answer_definitions/1
  # GET /answer_definitions/1.xml
  def show
    @answer_definition = AnswerDefinition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer_definition }
    end
  end

  # GET /answer_definitions/new
  # GET /answer_definitions/new.xml
  def new
    @answer_definition = AnswerDefinition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer_definition }
    end
  end

  # GET /answer_definitions/1/edit
  def edit
    @answer_definition = AnswerDefinition.find(params[:id])
  end

  # POST /answer_definitions
  # POST /answer_definitions.xml
  def create
    @answer_definition = AnswerDefinition.new(params[:answer_definition])

    respond_to do |format|
      if @answer_definition.save
        flash[:notice] = 'AnswerDefinition was successfully created.'
        format.html { redirect_to(@answer_definition) }
        format.xml  { render :xml => @answer_definition, :status => :created, :location => @answer_definition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /answer_definitions/1
  # PUT /answer_definitions/1.xml
  def update
    @answer_definition = AnswerDefinition.find(params[:id])

    respond_to do |format|
      if @answer_definition.update_attributes(params[:answer_definition])
        flash[:notice] = 'AnswerDefinition was successfully updated.'
        format.html { redirect_to(@answer_definition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answer_definitions/1
  # DELETE /answer_definitions/1.xml
  def destroy
    @answer_definition = AnswerDefinition.find(params[:id])
    @answer_definition.destroy

    respond_to do |format|
      format.html { redirect_to(answer_definitions_url) }
      format.xml  { head :ok }
    end
  end
end
