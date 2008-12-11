class TeamNotesReport < DefaultReport
  stage :header, :body
  required_option :user
  load_html_csv_text
  
  def setup
    self.data = TeamNotes.new(options)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => TeamNotesReport

    build :header do
      add_text "Report Generated at #{Time.now}"
    end

    build :body do
      pdf_writer.start_page_numbering(350,10,8,:center,"Page: <PAGENUM>")

      output << render_grouping(data.to_grouping, options.to_hash.merge(:formatter=> pdf_writer))
    end
  end

end


class TeamNotes

  def initialize(options={})
    @user = options[:user]
    @start_date = options[:start_date]
    @end_date = options[:end_date]
  end

  def to_table
    return unless defined? Ruport

    # rt = @user.student_comments.report_table(:all, :only => [:body])

    rt = StudentComment.report_table(:all,
      :conditions => ["created_at between ? and ?", @start_date.beginning_of_day, @end_date.end_of_day],
      :include => {:student => {:only => [], :methods => :fullname}, :user => {:only => [], :methods => :username}},
      :only => [:body, :created_at])

    unless rt.empty?
      rt.replace_column('created_at', 'Date') do |r|
        r['created_at'].to_date.to_s(:report)
      end
    end

    return rt if rt.column_names.blank?

    rt.rename_columns('body' => 'Team Note', 'user.username' => 'User Name', 'student.fullname' => 'Student')

    rt.reorder('Student', 'Date', 'User Name', 'Team Note')
    rt
  end

  def to_grouping
    @table ||= to_table
    return @table if  @table.column_names.blank?
    Ruport::Data::Grouping(@table, :by => 'Student')
  end
end
