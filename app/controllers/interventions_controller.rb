class InterventionsController < ApplicationController
  before_filter :find_intervention, :only => [:show, :edit, :update, :end, :destroy, :undo_end]
  skip_before_filter :verify_authenticity_token

  helper_method :new_path, :create_path

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
    @picker = Interventions::Goals.new(current_district,merged_params_and_values_from_session)
    #populate_definitions

    respond_to do |format|
      format.html # new.html.erb
      format.js {@picker = @picker.for_js; render @picker.js_create}
    end
  end

  # GET /interventions/1/edit
  def edit
    @recommended_monitors = @intervention.intervention_definition.recommended_monitors_with_custom.select(&:probe_definition)
    @intervention_probe_assignment = @intervention.intervention_probe_assignment
    @users = [nil] | current_school.assigned_users.collect{|e| [e.fullname, e.id]}
    @intervention_comment = @intervention.comments.detect(&:new_record?) || InterventionComment.new
  end

  # POST /interventions
  def create
    params["intervention"]["intervention_probe_assignment"]["probe_definition_attributes"].merge! params["probe_definition"] if params["probe_definition"]
    params[:intervention][:comment_author] = current_user.id

    @intervention = build_from_session_and_params

    if @intervention.save
      flash[:notice] = "Intervention was successfully created. #{@intervention.autoassign_message} "
      redirect_to(student_url(current_student, :tn=>0, :ep=>0))
    else
      puts @intervention.inspect
      #raise @intervention.errors.inspect
      @picker = Interventions::Goals.new(current_district,merged_params_and_values_from_session)
      # This is to make validation work
=begin      i = @intervention
      @intervention_comment = @intervention.comments.first
      @goal_definition = @intervention.goal_definition
      @objective_definition=@intervention.objective_definition
      @intervention_cluster = @intervention.intervention_cluster
      @intervention_definition = @intervention.intervention_definition
      populate_goals
      @intervention_probe_assignment.valid? if @intervention_probe_assignment #So errors show up on creation  TODO REFACTOR
      @intervention = i
      # end code to make validation work
=end
      render :action => "new"
    end
  end

  # PUT /interventions/1
  def update
    if params[:intervention]
      params[:intervention][:participant_user_ids] ||=[]
      params[:intervention][:intervention_probe_assignment] ||= {}
      params[:intervention][:comment_author] = current_user.id
    end

    respond_to do |format|
      if @intervention.update_attributes(params[:intervention])
        flash[:notice] = 'Intervention was successfully updated.'
        format.html { redirect_to(student_url(current_student, :tn => 0, :ep => 0)) }
      else
        format.html do
          edit
          params[:enter_score] = true
          #@intervention_comment = InterventionComment.new(params[:intervention][:comment]) if params[:intervention]
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
      format.html {render :layout => false}
      format.js
    end
  end

  private

  def find_intervention
    if current_student.blank?
     # alternate entry point
      @intervention = Intervention.find(params[:id])
      if @intervention.try(:student).try(:belongs_to_user?,current_user)
        setup_session_from_user_and_student(current_user,@intervention.student)
      else
        flash[:notice] = 'Intervention not available'
        redirect_to logout_url and return false
      end
    else
      @intervention = current_student.interventions.find(params[:id])
    end
  end

  def readonly?
    params[:action] == "show"
  end

  def new_path(*args)
    new_intervention_path(*args)
  end

  def create_path(*args)
    interventions_path(*args)
  end

  def merged_params_and_values_from_session
    params.merge(
      :user_id => current_user.id,
      :selected_ids => selected_student_ids,
      :school_id => current_school_id,
      :current_student => current_student,
      :current_district => current_district,
      :current_user => current_user
    )
  end

  def values_from_session
    {:user_id => current_user.id,
      :selected_ids => selected_student_ids,
      :school_id => current_school_id
    }

  end

  def build_from_session_and_params
    params[:intervention] ||= {}
    @intervention = current_student.interventions.build(params[:intervention].merge(values_from_session))
    @intervention_probe_assignment = @intervention.intervention_probe_assignment if @intervention.intervention_probe_assignment
    @intervention
  end

  def populate_intervention
    return if params[:intervention_definition] and params[:intervention_definition][:id].blank?
    find_intervention_definition
    @recommended_monitors = @intervention_definition.recommended_monitors_with_custom.select(&:probe_definition)
    params[:intervention] ||= {}
    params[:intervention].merge!(:intervention_definition => @intervention_definition)
    build_from_session_and_params
    @users = [nil] | current_school.assigned_users.collect{|e| [e.fullname, e.id]}
  end
end
