class ReportsController < ApplicationController
  additional_read_actions :team_notes

  def regenerate_intervention_pdfs
    CreateInterventionPdfs.generate(current_district)
  end

  def team_notes
    @today = Date.current

    if request.post?
      @start_date = build_date(params[:start_date])
      @end_date   = build_date(params[  :end_date])
    else
      @start_date = @end_date = @today
    end

    handle_report_postback TeamNotesReport, 'team_notes', :user => current_user, :start_date => @start_date, :end_date => @end_date
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
      Date.new(date_hash[:year].to_i, date_hash[:month].to_i, date_hash[:day].to_i)
    else
      nil
    end
  end

end
