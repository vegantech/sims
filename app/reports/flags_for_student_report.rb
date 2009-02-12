# Report for flags for a given student, used in the overall_report pdf

class FlagsForStudentReport < DefaultReport
  stage  :body
  required_option :student
  load_html_csv_text

  def setup
    self.data = FlagSummary.new(options)
  end
end

class FlagSummary

  def initialize(options = {})
    @student = options[:student]
  end

  def to_table
    return unless defined? Ruport
		table = @student.flags.report_table(:all, :only => %w[category reason type user_id updated_at])
		table.rename_column('type', 'sti_type')

		table.replace_column('user_id') {|r| (User.find_by_id(r['user_id']) || User.new).fullname}
		table.replace_column('updated_at') {|r| (r['updated_at'].to_s(:long))}

		sort_lambda = lambda {|g| ['Attendance','Behavior', 'Language Arts', 'Math', 'Custom Flags', 'IgnoreFlags'].index(g.name) || 999 }
		table.sort_rows_by sort_lambda
  end

  def to_grouping
    @table ||= to_table
    return @table if @student.flags.empty? 
    sort_lambda = lambda {|g| ['SystemFlag', 'CustomFlag', 'IgnoreFlag'].index(g.name) || 999 }
    Ruport::Data::Grouping(@table, :by => 'sti_type').sort_grouping_by sort_lambda
  end
end
