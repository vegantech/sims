require 'ruport'

class UserInterventionsReport < DefaultReport
  stage :header, :body
  required_option :user
  load_html_csv_text

  def setup
    self.data = UserInterventions.new(options)
  end

  class HTML < Ruport::Formatter::HTML
    renders :html, :for => UserInterventionsReport
    build :header do
      output << "Report Generated at #{Time.now.to_s(:long)}"
    end

    build :body do
      output << data.to_grouping(format=:html).to_html.gsub('<table>', '<table class="user_interventions_table">')
    end
  end



  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => UserInterventionsReport
    build :header do
      add_text "Report Generated at #{Time.now}"
    end

    build :body do
      ::PDF::Writer::TagAlink.style={:factor=>0.05, :text_color=>Color::RGB::Blue, :draw_line=>false, :line_style=>{:dash=>{:phase=>0, :pattern=>[]}}, :color=>Color::RGB::Blue}
      pdf_writer.start_page_numbering(350,10,8,:center,"Page: <PAGENUM>")

      output << render_grouping(data.to_grouping(:pdf), options.to_hash.merge(:formatter=> pdf_writer))
      ::PDF::Writer::TagAlink.style=nil
    end
  end
end


class UserInterventions

  def initialize(options = {})
    @user = options[:user]
  end

  def to_table(format=nil)
    return unless defined? Ruport
    if [:pdf,:html].include?format
      title_method = :bolded_report_summary
    else
      title_method = :report_summary
    end

    table = @user.intervention_participants.report_table(:all,
      :only => [],
      :methods => :role_title,
      :include => {:intervention => {:only => [:start_date, :end_date, :active],
                                     :methods => [title_method, :frequency_summary, :time_length_summary],
                                     :include => {:student => {:only => [], :methods => [:fullname]}}}})

    return table if table.column_names.blank?

    table.rename_columns("role_title" => "Role", "intervention.#{title_method}" => "Title / Status",
      "intervention.start_date" => "Start Date", "intervention.frequency_summary" => "Frequency",
      "intervention.active" => "Active", "intervention.time_length_summary" => "Time Length",
      "intervention.end_date" => "End Date", 'student.fullname' => 'Student Name')

    table.reorder("Title / Status", "Role", "Start Date", "End Date", "Frequency", "Time Length", "Active", "Student Name")
    table
  end

  def to_grouping(format=nil)
    @table ||= to_table(format)
    return @table if @table.column_names.blank?
    Ruport::Data::Grouping(@table, :by => "Student Name")
  end
end
