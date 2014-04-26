require 'csv'
class ReportsController < ApplicationController
  skip_before_filter :authorize, :authenticate_user!, :only => [:intervention_definition_summary_report]
  skip_before_filter :verify_authenticity_token

  before_filter :check_student, :only => [:student_interventions, :student_overall_options, :student_overall]
  caches_page :intervention_definition_summary_report

  # TODO: Add an actual link to this in the GUI!
  # Ported from Madison SIMS on 2/12/09, SDA
  # flagged students for a given school (and optional grade)
  def student_flag_summary
    search_criteria=(session[:search] || {}).merge(
      :school_id => current_school_id,
      :user => current_user)
    request.env['HTTP_REFERER'] ||= '/'
    @reporter = StudentFlagReport.new(search_criteria)
    handle_report_postback "student_flag_summary", 'student_flag_summary'
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
    handle_report_postback "student_interventions", @student.fullname, :student => @student
  end

  def user_interventions
    user = current_user
    @today = Date.current

    if request.post?
      @start_date = build_date(params[:start_date])
      @end_date   = build_date(params[:end_date])
      @filter = params[:report_params][:filter]
      @interventions = Intervention.for_user_interventions_report(current_user,@filter,@start_date,@end_date) if request.post?
    else
      @start_date = 3.years.ago
        @end_date = @today
    end

    handle_report_postback "user_interventions", user.fullname, :user => current_user
  end

  STUDENT_OVERALL_OPTIONS_HELP={
    :top_summary =>"Includes basic student information, flag icons, enrollments.  This is what is in the gray box at the top of the profile.",
    :extended_profile => "The content of the extended profile, if available (Adult contacts, address, test scores, siblings, extra info)",
    :flags => "A list of the system, custom, and ignored flags for this student",
    :consultation_forms => "A breakdown of the team consultations and replies for this student",
    :team_notes => "A list of team notes (student comments.)",
    :intervention_summary => "The summary table for interventions (what you see on the profile page.)  Does not include scores or intervention comments.",
    :intervention_detail => "The details of interventions including scores, graphs, and comments.",
    :checklists_and_or_recommendations => "Checklists and  Recommendations detail"
  }
  def student_overall_options
    # present choices for report, maybe merge this in via postback if it seems right.
    @opts = [:top_summary, :extended_profile, :flags, :consultation_forms, :team_notes, :intervention_summary,:intervention_detail, :checklists_and_or_recommendations]
    @student = current_student
    @filetypes = ['html']
    @filetypes << ['pdf'] if defined? PDF::HTMLDoc
  end

  def student_overall
    # process params from student_overall_options
    params[:format] = params[:report_params][:format] if params[:report_params]
    params[:format] = :html unless defined? PDF::HTMLDoc
    request.format = params[:format] if params[:format]

    @opts = params[:report_params] || {}
    @student = current_student

    respond_to do |format|
      format.html {}
      format.pdf {send_data(render_to_pdf({ :action => 'student_overall', :layout => "pdf_report" }), :filename => "#{@student.number}.pdf" )}
    end
  end

  def team_notes
    @today = Date.current

    if request.post?
      @start_date = build_date(params[:start_date])
      @end_date   = build_date(params[:end_date])
      @sort_field = params[:report_params][:sort_field]
      @content = params[:report_params][:content]
      @reporter = TeamNotesReport.new(:user => current_user, :school => current_school, :start_date => @start_date, :end_date => @end_date, :sort_field=>@sort_field, :content => @content)
    else
      @start_date = @end_date = @today
    end

    handle_report_postback "team_notes", 'team_notes', :user => current_user, :school => current_school, :start_date => @start_date, :end_date => @end_date, :sort_field=>@sort_field, :content => @content
  end

  def intervention_definition_summary_report
    @district = District.find(params[:district_id])
    @objective_definition = @district.objective_definitions.find_by_filename(params[:filename])
    #read cached html
    #pdf
    #html
    respond_to do |format|
     format.html { render :layout => "pdf" }
     format.pdf { render :text => PDFKit.new(intervention_definition_summary_report_html).to_pdf }
    end
  end

  private
  def intervention_definition_summary_report_html
    filename = File.join("system","district_generated_docs",@district.id.to_s,"#{params[:filename].gsub(/\./,'')}.html").to_s
    abs_filename = Rails.root.join("public", filename).to_s
    if File.exist?(abs_filename)
      File.read(abs_filename)
    else
      html = render_to_string("intervention_definition_summary_report.html",:layout => "pdf")
      cache_page(html,"/#{filename}")
      html
    end
  end

  def handle_report_postback report_class, base_filename, report_options = {}
    @filetypes = ['html', 'pdf', 'csv']
    @selected_filetype = 'html'

    if request.post? and params[:generate] and params[:report_params]
      generate_report report_class, base_filename, report_options
    end
  end

  def generate_report report_class, base_filename, report_options
    fmt = params[:report_params][:format]
    if report_class.class == Class
      @report = report_class.send("render_#{fmt}".to_sym, report_options)
    else
      @report = render_to_string("#{report_class}",:formats => [:csv] ,:layout => nil) if fmt == "csv"
      @report = render_to_string("_#{report_class}",:formats => [:html] ,:layout => nil) if fmt == "html"
      @report = PDFKit.new(render_to_string("_#{report_class}",:formats => [:html], :layout => "pdf")).to_pdf if fmt == "pdf"
    end

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
        flash.now[:notice] = 'Invalid date chosen.  Used today instead.'
        Date.today
      end
    end
  end

  def readonly?
    true
  end
end
