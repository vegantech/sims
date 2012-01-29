class InterventionsController < ApplicationController
  additional_write_actions 'end', 'ajax_probe_assignment', 'undo_end', 'add_benchmark'
  before_filter :find_intervention, :only => [:show, :edit, :update, :end, :destroy, :undo_end]
  skip_before_filter :authorize, :only => [:add_benchmark]
  skip_before_filter :verify_authenticity_token

  include PopulateInterventionDropdowns

  def index
    redirect_to root_url
  end

  # GET /interventions/1
  def show
    @intervention_probe_assignment = @intervention.intervention_probe_assignments.first
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /interventions/new
  def new
    if current_student.blank?
      flash[:notice] = "Please select a student."
      redirect_to students_url and return
    end

    flash.keep(:custom_intervention)
    flash[:custom_intervention] ||= params[:custom_intervention]
    @intervention_comment = InterventionComment.new
    @tiers=current_district.tiers

    respond_to do |format|
      format.html { populate_goals }# new.html.erb
    end
  end

  # GET /interventions/1/edit
  def edit
    @recommended_monitors = @intervention.intervention_definition.recommended_monitors_with_custom.select(&:probe_definition)
    @intervention_probe_assignment = @intervention.intervention_probe_assignment
    @users = [nil] | current_school.assigned_users.collect{|e| [e.fullname, e.id]}
    @intervention_comment = InterventionComment.new
    @tiers = current_district.tiers
  end

  # POST /interventions
  def create
    params["intervention"]["intervention_probe_assignment"]["probe_definition_attributes"].merge! params["probe_definition"] if params["probe_definition"]

    @intervention = build_from_session_and_params
    @tiers=current_district.tiers

    if @intervention.save
      flash[:notice] = "Intervention was successfully created. #{@intervention.autoassign_message} "
      redirect_to(student_url(current_student, :tn=>0, :ep=>0))
    else
      # This is to make validation work
      i = @intervention
      @goal_definition = @intervention.goal_definition
      @objective_definition=@intervention.objective_definition
      @intervention_cluster = @intervention.intervention_cluster
      @intervention_definition = @intervention.intervention_definition
      populate_goals
      @intervention_probe_assignment.valid? if @intervention_probe_assignment #So errors show up on creation  TODO REFACTOR
      @intervention = i
      flash.keep(:custom_intervention)
      # end code to make validation work
      render :action => "new"
    end
  end

  # PUT /interventions/1
  def update
    if params[:intervention]
      params[:intervention][:participant_user_ids] ||=[]
      params[:intervention][:intervention_probe_assignment] ||= {}
      params[:intervention][:comment_author] = current_user.id if params[:intervention][:comment]
    end
    @tiers = current_district.tiers

    respond_to do |format|
      if @intervention.update_attributes(params[:intervention])
        flash[:notice] = 'Intervention was successfully updated.'
        format.html { redirect_to(student_url(current_student, :tn => 0, :ep => 0)) }
      else
        format.html do
          edit
          params[:enter_score] = true
          @intervention_comment = InterventionComment.new(params[:intervention][:comment]) if params[:intervention]
          render :action => "edit"
        end
      end
    end
  end

  # DELETE /interventions/1
  def destroy
    logger.info("DELETION- #{current_user} at #{current_user.district} removed #{@intervention.title} from #{current_student}")
    @intervention.destroy

    respond_to do |format|
      format.html { redirect_to(current_student) }
    end
  end

  def end
  @intervention.end(current_user.id, params[:end_reason], params[:fidelity])
     respond_to do |format|
      format.html { redirect_to(current_student) }
    end
  end

  def undo_end

    @intervention.undo_end
    redirect_to current_student
  end

  def ajax_probe_assignment
    flash.keep(:custom_intervention)
    @intervention = current_student.interventions.find_by_id(params[:intervention_id]) || Intervention.new
    if params[:id] == 'custom'
      @intervention_probe_assignment = @intervention.intervention_probe_assignments.build if @intervention
      if @intervention_probe_assignment and  @intervention_probe_assignment.probe_definition.blank?
        @intervention_probe_assignment.build_probe_definition
      end
    else
      @intervention_probe_assignment = @intervention.intervention_probe_assignments.find_by_probe_definition_id(params[:id]) if @intervention
      unless @intervention_probe_assignment
        rec_mon = RecommendedMonitor.find_by_probe_definition_id(params[:id])
        @intervention_probe_assignment = rec_mon.build_intervention_probe_assignment if rec_mon
      end
    end
    respond_to do |format|
      format.html {render :partial => 'interventions/probe_assignments/intervention_probe_assignment_detail'}
      format.js
    end
  end

  def add_benchmark
    @probe_definition_benchmark = ProbeDefinitionBenchmark.new
    render :action => 'interventions/probe_assignments/add_benchmark'
  end

  private

  def find_intervention
    if current_student.blank?
     # alternate entry point
      intervention = Intervention.find(params[:id])
      if intervention && intervention.student && intervention.student.belongs_to_user?(current_user)
        student = intervention.student
        session[:school_id] = (student.schools & current_user.schools).first.id
        session[:selected_student] = student.id
        self.selected_student_ids = [student.id]
        @intervention = intervention
      else
        flash[:notice] = 'Intervention not available'
        redirect_to logout_url and return false
      end
    else
      @intervention = current_student.interventions.find(params[:id])
    end

    unless @intervention
      flash[:notice] = "Intervention could not be found"
      redirect_to current_student and return false
    end
  end
end
