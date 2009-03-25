class StudentFlagReport < DefaultReport
  stage :header, :body
  required_option :school
  load_html_csv_text
  
  def setup
    self.data = StudentFlags.new(options)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StudentFlagReport
    build :header do
      add_text "Report Generated at #{Time.now}"
    end

    build :body do
      pdf_writer.start_page_numbering(350,10,8, :center, "Page: <PAGENUM>")
      output << render_grouping(data.to_grouping, options.to_hash.merge(:formatter => pdf_writer))
    end
  end

end

class StudentFlags

  def initialize(options = {})
    @school = School.find(options[:school])
    @grade = options[:grade]
  end

  def to_table
    grade = @grade
    return unless defined? Ruport
    
    srt = Ruport::Data::Table(["Name", "Student Num", "Grade", "Flag Reason", "FlagType"])

    #This hasn't been ported yet,  there's mo person_id in open sims.
    return srt  #Remove this return
=begin    ### BEGIN INVALID CODE
    puts "ADD Grade to HEADER " if grade
    opts = ["fullname", "studentNum"]
    opts << "grade" unless grade
    # h = {:conditions => ["grade=?",grade]} if grade
    students = @school.students.find_flagged_students.select{|e| e.person_id if grade.blank? || e.grade == grade }

    students.each do |student|
      student.flags.current.each do |flagtype,flags|
        srt <<  [student.fullname, student.studentNum, student.grade, flags.collect(&:summary).join(" "),Flag::TYPES[flagtype][:humanize]]
      end
    end


    
    students = @school.students.find_flagged_students("ignored").select{|e| e.person_id if grade.blank? || e.grade == grade }
    students.each {|student| srt << [student.fullname, student.studentNum,student.grade, student.ignore_flags_summarize_reasons, "Ignored Flags"]}
    students = @school.students.find_flagged_students("custom").select{|e| e.person_id if grade.blank? || e.grade == grade }
    students.each {|student| srt << [student.fullname, student.studentNum, student.grade, student.custom_flags_summarize_reasons, "Custom Flags"]}
    @table = srt
    return srt
    ### END INVALID CODE
=end
  end

  def to_grouping
    @table ||= to_table
    sort_lambda = lambda {|g| ["Attendance", "Behavior", "Language Arts", "Math", "Custom Flags", "IgnoreFlags"].index(g.name)  ||999      }
    Ruport::Data::Grouping(@table, :by => "FlagType").sort_grouping_by sort_lambda
  end
end
