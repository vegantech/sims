class Interventions::ParticipantsController < ApplicationController
  before_filter :load_intervention
  # GET /intervention_participants/new
  # GET /intervention_participants/new.xml
  def new
    @intervention_participant = @intervention.intervention_participants.build
    @users=current_school.users

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intervention_participant }
    end
  end

    # POST /intervention_participants
  # POST /intervention_participants.xml
  def create
    @intervention_participant = @intervention.intervention_participants.build(params[:intervention_participant])

    respond_to do |format|
      if @intervention_participant.save
        #TODO this makes more sense in the model if we move intervention participants to the intervention edit, we just would need some check to make sure we're
        #not sending a duplicate email.   But it's easier to put it here for now.
        #send email here
        Notifications.deliver_intervention_participant_added(@intervention_participant)
        flash[:notice] = "#{@intervention_participant.role_title} added."
        format.html { redirect_to(@intervention) }
        format.xml  { render :xml => @intervention_participant, :status => :created, :location => @intervention_participant }
      else
        @users=current_school.users
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervention_participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /intervention_participants/1
  # PUT /intervention_participants/1.xml
  def update
    #change the role
    @intervention_participant = @intervention.intervention_participants.find(params[:id])

    @intervention_participant.toggle_role!
    flash[:notice] = @intervention_participant.fullname + "is now a" + @intervention_participant.role_title

    respond_to do |format|
        format.html { redirect_to(@intervention) }
      end
  end

  # DELETE /intervention_participants/1
  # DELETE /intervention_participants/1.xml
  def destroy
    @intervention_participant = @intervention.intervention_participants.find(params[:id])
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
