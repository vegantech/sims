class InterventionsController < ApplicationController
  # GET /interventions
  # GET /interventions.xml
  def index
    @interventions = Intervention.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interventions }
    end
  end

  # GET /interventions/1
  # GET /interventions/1.xml
  def show
    @intervention = current_student.interventions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @intervention }
    end
  end

  # GET /interventions/new
  # GET /interventions/new.xml
  def new
    #For now we aren't using ajax.  I'm not sure what to do here.   
    #The next step would be to include them on the page
    #then enable ajax
    #
    #redirect_to interventions_goals_url and return unless params[:intervention]
    
    @intervention= build_from_session_and_params  #may only be appropriate in html with dropdowns
    respond_to do |format|
      format.html { populate_dropdowns }# new.html.erb
      format.xml  { render :xml => @intervention }
    end
  end

  # GET /interventions/1/edit
  def edit
    @intervention = current_student.interventions.find(params[:id])
  end

  # POST /interventions
  # POST /interventions.xml
  def create
    @intervention= build_from_session_and_params


    respond_to do |format|
      if @intervention.save
        flash[:notice] = 'Intervention was successfully created.'
        format.html { redirect_to(@intervention.student) }
        format.xml  { render :xml => @intervention, :status => :created, :location => @intervention }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervention.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interventions/1
  # PUT /interventions/1.xml
  def update
    @intervention = current_student.interventions.find(params[:id])

    respond_to do |format|
      if @intervention.update_attributes(params[:intervention])
        flash[:notice] = 'Intervention was successfully updated.'
        format.html { redirect_to(@intervention) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervention.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interventions/1
  # DELETE /interventions/1.xml
  def destroy
    @intervention = current_student.interventions.find(params[:id])
    @intervention.destroy

    respond_to do |format|
      format.html { redirect_to(interventions_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def values_from_session
    { :user_id => session[:user_id],
      :selected_ids => selected_students_ids
    }
  end

  def build_from_session_and_params
    params[:intervention] ||={}
    @intervention = current_student.interventions.build_and_initialize(params[:intervention].merge(values_from_session))
  end

  #FIXME these should somehow be extracted
  #if there's only one item, add the next level down (I'll deal with that later) 
  def populate_dropdowns
    @goal_definitions=current_district.goal_definitions
    if @intervention.intervention_definition
      @goal_definition=@goal_definitions.find(@intervention.goal_definition.id)
      @objective_definitions=@goal_definition.objective_definitions
      @objective_definition = @objective_definitions.find(@intervention.objective_definition.id)
      @intervention_clusters = @objective_definition.intervention_clusters
      @intervention_cluster = @intervention_clusters.find(@intervention.intervention_cluster.id)
      @intervention_definitions = @intervention_cluster.intervention_definitions
      @intervention_definition = @intervention_definitions.find(@intervention.intervention_definition.id)
      
    end


  end

end
