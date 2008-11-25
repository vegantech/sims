class Interventions::ParticipantsController < ApplicationController
  before_filter :load_intervention
  # GET /intervention_participants/new
  # GET /intervention_participants/new.xml
  def new
    @intervention_participant = InterventionParticipant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intervention_participant }
    end
  end

  # GET /intervention_participants/1/edit
  def edit
    @intervention_participant = InterventionParticipant.find(params[:id])
  end

  # POST /intervention_participants
  # POST /intervention_participants.xml
  def create
    @intervention_participant = InterventionParticipant.new(params[:intervention_participant])

    respond_to do |format|
      if @intervention_participant.save
        flash[:notice] = 'InterventionParticipant was successfully created.'
        format.html { redirect_to(@intervention) }
        format.xml  { render :xml => @intervention_participant, :status => :created, :location => @intervention_participant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervention_participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /intervention_participants/1
  # PUT /intervention_participants/1.xml
  def update
    @intervention_participant = InterventionParticipant.find(params[:id])

    respond_to do |format|
      if @intervention_participant.update_attributes(params[:intervention_participant])
        flash[:notice] = 'InterventionParticipant was successfully updated.'
        format.html { redirect_to(@intervention) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervention_participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /intervention_participants/1
  # DELETE /intervention_participants/1.xml
  def destroy
    @intervention_participant = InterventionParticipant.find(params[:id])
    @intervention_participant.destroy

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
