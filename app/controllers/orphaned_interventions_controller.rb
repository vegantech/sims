class OrphanedInterventionsController < ApplicationController
  # GET /grouped_progress_entries
  # GET /grouped_progress_entries.xml
  def index
    if current_school.blank?
     flash[:notice] = "Please select a school first"  
    else
      @users =  current_school.assigned_users
    end
    @interventions = current_user.orphaned_interventions_where_principal(current_school)
    @new_participant = InterventionParticipant.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interventions }
    end
  end


  def new
    #new participant
  end

  def edit
    #not used
  end

  def show
    #not used
  end

  def update
    @intervention = Intervention.find_by_id(params[:id])
    if params[:user_id].present?  && !@intervention.participant_user_ids.include?(params[:user_id].to_i)
      @participant=@intervention.intervention_participants.build(:user_id => params[:user_id])
      if @participant.valid?
        @participant.save!
      else
        @participant = nil
      end
    end
    
    respond_to do |format|
      format.html 
      format.js
    end
    #create participant
  end

  def create
    #bulk ending,  TODO add validation for end reason
    Intervention.find_all_by_id(params[:id]).each do |intervention|
      if intervention.student.principals.include? current_user
        intervention.end current_user
      end
    end

    redirect_to orphaned_interventions_url
  end

  def destroy
    @intervention_participant=InterventionParticipant.find(params[:id])
    @intervention_participant.destroy if @intervention_participant.intervention.student.belongs_to_user?(current_user)

    respond_to do |format|
      format.html
      format.js  
    end
  end


end
