class ReportsController < ApplicationController
  additional_read_actions :team_notes, :student_overall, :student_overall_options, :student_interventions, :student_flag_summary, :user_interventions, :grouped_progress_entry

  # TODO: Add an actual link to this in the GUI!
  # Ported from Madison SIMS on 2/12/09, SDA
  # flagged students for a given school (and optional grade)
  def student_flag_summary
    @school = School.find session[:school_id] if session[:school_id]
    request.env['HTTP_REFERER'] ||= '/'
    flash[:notice] = "Choose a school first" and redirect_to :back and return if @school.blank?

    @grades = @school.enrollments.grades
    # @grades[0][0] = 'All Grades'
    grade = params[:report_params][:grade] if params[:report_params]
    grade = nil if grade.blank? or grade.include?("*")
    handle_report_postback StudentFlagReport, 'student_flag_summary', :grade => grade, :school => @school
  end

  def grouped_progress_entry
    flash[:notice]="You must complete a search first" and redirect_to root_url and return  if session[:search].blank?
    search_criteria=session[:search].merge(
      :school_id => current_school_id,
      :user => current_user)
    @grouped_progress_entries = GroupedProgressEntry.all(current_user,search_criteria)
  end

  # interventions for a single student
  def student_interventions
    @student = current_student
    flash[:notice] = "Select a student first" and redirect_to :back and return if @student.nil?
    handle_report_postback StudentInterventionsReport, @student.fullname, :student => @student
  end

  def user_interventions
    user = current_user
    handle_report_postback UserInterventionsReport, user.fullname, :user => current_user
  end

  def student_overall_options
    # present choices for report, maybe merge this in via postback if it seems right. 
    @opts = [:top_summary, :extended_profile, :flags, :team_notes, :intervention_summary, :checklists_and_or_recommendations, :consultation_forms]
    @student = current_student
    @filetypes = ['html']
    @filetypes << ['pdf'] if defined? PDF::HTMLDoc
  end

  def student_overall
    # process params from student_overall_options
    params[:format] = params[:report_params][:format] if params[:report_params]
    params[:format] = 'html' unless defined? PDF::HTMLDoc

    @opts = params[:report_params] || {}
    @student = current_student

    respond_to do |format|
      format.html {}
      format.pdf {send_data render_to_pdf({ :action => 'student_overall', :layout => "pdf_report" }), :filename => "#{@student.number}.pdf" }
    end
  end

  def team_notes
    @today = Date.current

    if request.post?
      @start_date = build_date(params[:start_date])
      @end_date   = build_date(params[:end_date])
      @sort_field = params[:report_params][:sort_field]
      @content = params[:report_params][:content]
    else
      @start_date = @end_date = @today
    end

    handle_report_postback TeamNotesReport, 'team_notes', :user => current_user, :school => current_school, :start_date => @start_date, :end_date => @end_date, :sort_field=>@sort_field, :content => @content
  end

  private

  def handle_report_postback report_class, base_filename, report_options = {}
    flash[:notice] = "Sorry, reports are not available" and redirect_to :back and return unless defined? Ruport

    @filetypes = ['html', 'pdf', 'csv']
    @selected_filetype = 'html'

    if request.post? and params[:generate] and params[:report_params]
      generate_report report_class, base_filename, report_options
    end
  end

  def generate_report report_class, base_filename, report_options
    fmt = params[:report_params][:format]
    @report = report_class.send("render_#{fmt}".to_sym, report_options)

    if ['csv','pdf'].include? fmt
      pdf_headers if fmt == 'pdf'
      send_data @report, :type => "application/#{fmt}",
                         :disposition => "attachment",
                         :filename => "#{base_filename}.#{fmt}"
    end
  end

  def pdf_headers
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] ||= ''
      headers['Cache-Control'] ||= ''
    else
      headers['Pragma'] ||= 'no-cache'
      headers['Cache-Control'] ||= 'no-cache, must-revalidate'
    end
    headers["Content-Type"] ||= 'application/pdf'
  end

  def build_date date_hash
    if date_hash
      begin
        Date.new(date_hash[:year].to_i, date_hash[:month].to_i, date_hash[:day].to_i)
      rescue ArgumentError
        flash[:notice] = 'Invalid date chosen.  Used today instead.'
        Date.today
      end
    else
      nil
    end
  end
end
