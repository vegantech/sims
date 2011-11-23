class TeamConsultationsController < ApplicationController
  before_filter :require_current_school
  additional_write_actions :complete
  # GET /team_consultations/1
  # GET /team_consultations/1.xml
  def show
    @team_consultation = TeamConsultation.find(params[:id])

    respond_to do |format|
      format.js
      format.html # show.html.erb
      format.xml  { render :xml => @team_consultation }
    end
  end

  # GET /team_consultations/new
  # GET /team_consultations/new.xml
  def new
    @team_consultation = TeamConsultation.new
    @team_consultation.consultation_forms.build if @team_consultation.consultation_forms.blank?
    @teams = current_school.school_teams

    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.xml  { render :xml => @team_consultation }
    end
  end

  # GET /team_consultations/1/edit
  def edit
    @team_consultation = TeamConsultation.find(params[:id])
    @teams = current_school.school_teams
    respond_to do |format|
      format.js { render :action => 'new'}
      format.html # new.html.erb
      format.xml  { render :xml => @team_consultation }
    end
  end

  # POST /team_consultations
  # POST /team_consultations.xml
  def create
    params[:team_consultation] ||= {}
    params[:team_consultation].merge!(:student_id => current_student_id, :requestor_id => current_user_id)
    params[:team_consultation][:draft] = true if params[:commit] == "Save as Draft"   #the js in the view stopped working?
    @team_consultation = TeamConsultation.new(params[:team_consultation])

    respond_to do |format|
      if @team_consultation.save
        unless @team_consultation.draft?
          msg="<p>The concern note has been sent to #{@team_consultation.school_team}.</p>  <p>A discussion about this student will occur at an upcoming team meeting.</p>"
        else
          msg = 'The Team Consultation Draft was saved.'
        end
        
        format.html { flash[:notice]=msg; redirect_to(current_student) }
        format.js { flash.now[:notice] = msg; responds_to_parent {render}}
        format.xml  { render :xml => @team_consultation, :status => :created, :location => @team_consultation }
      else
        @recipients = current_school.school_teams
        format.html { render :action => "new" }
        format.js {  responds_to_paremt {render}  }
        format.xml  { render :xml => @team_consultation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /team_consultations/1
  # PUT /team_consultations/1.xml
  def update
    @team_consultation = TeamConsultation.find(params[:id])

    respond_to do |format|
      if @team_consultation.update_attributes(params[:team_consultation])
        if @team_consultation.draft?
          msg="<p>The concern note has been sent to #{@team_consultation.school_team}.</p>  <p>A discussion about this student will occur at an upcoming team meeting.</p>"
        else
          msg = 'TeamConsultation was successfully updated.'
        end
        format.js { flash.now[:notice] = msg; render :action => 'create'}
        format.html { redirect_to(@team_consultation.student) }
        format.xml  { head :ok }
      else
        format.js { render :action => 'new'}
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team_consultation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /team_consultations/1
  # DELETE /team_consultations/1.xml
  def destroy
    @team_consultation = current_user.team_consultations.find(params[:id])
    @team_consultation.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to(@team_consultation.student) }
      format.xml  { head :ok }
    end
  end

  def complete
    @team_consultation = TeamConsultation.find(params[:id])
    @team_consultation.complete! and flash[:notice] = "Marked complete" if @team_consultation.recipients.include?(current_user)
    
    respond_to do |format|
      format.js
    end
    

  end
end
