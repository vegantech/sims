class Interventions::ParticipantsController < ApplicationController
  before_filter :load_intervention
  # GET /intervention_participants/new
  # GET /intervention_participants/new.xml
  def new
    @intervention_participant = @intervention.intervention_participants.build
    @users = [nil] | current_school.assigned_users

    respond_to do |format|
      format.html # new.html.erb
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
        flash[:notice] = "#{@intervention_participant.role_title} added."
        format.html { redirect_to(@intervention) }
      else
        @users = [nil] | current_school.assigned_users
        format.html { render action: "new" }
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
    @intervention_participant = @intervention.intervention_participants.find_by_user_id(params[:id])
    @intervention_participant.destroy
    respond_to do |format|
      format.js {}
      format.html{ redirect_to(@intervention)}
    end
  end

  protected
  def load_intervention
    @intervention = current_student.interventions.find(params[:intervention_id])
  end
end
