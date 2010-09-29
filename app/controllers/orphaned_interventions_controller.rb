class OrphanedInterventionsController < ApplicationController
  # GET /grouped_progress_entries
  # GET /grouped_progress_entries.xml
  def index
    @interventions = current_user.orphaned_interventions_where_principal
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
