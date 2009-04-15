require 'ruport'

class UserInterventionsReport < DefaultReport
  stage :header, :body
  required_option :user
  load_html_csv_text

  def setup
    self.data = UserInterventions.new(options)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => UserInterventionsReport
    build :header do
      add_text "Report Generated at #{Time.now}"
    end

    build :body do
      pdf_writer.start_page_numbering(350,10,8,:center,"Page: <PAGENUM>")

      output << render_grouping(data.to_grouping, options.to_hash.merge(:formatter=> pdf_writer))
    end
  end
end


class UserInterventions

  def initialize(options = {})
    @user = options[:user]
  end

  def to_table
    return unless defined? Ruport

    table = @user.intervention_participants.report_table(:all,
      :only => [],
      :methods => :role_title,
      :include => {:intervention => {:only => [:start_date, :end_date, :active],
                                     :methods => [:report_summary, :frequency_summary, :time_length_summary],
                                     :include => {:student => {:only => [], :methods => [:fullname]}}}})

    return table if table.column_names.blank?

    table.rename_columns("role_title" => "Role", "intervention.report_summary" => "Title / Status",
      "intervention.start_date" => "Start Date", "intervention.frequency_summary" => "Frequency",
      "intervention.active" => "Active", "intervention.time_length_summary" => "Time Length",
      "intervention.end_date" => "End Date", 'student.fullname' => 'Student Name')

    table.reorder("Title / Status", "Role", "Start Date", "End Date", "Frequency", "Time Length", "Active", "Student Name")
    table
  end

  def to_grouping
    @table ||= to_table
    return @table if @table.column_names.blank?
    Ruport::Data::Grouping(@table, :by => "Student Name")
  end
end