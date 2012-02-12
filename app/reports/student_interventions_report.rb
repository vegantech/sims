# Start of Interventions Report for a student
class StudentInterventionsReport <  DefaultReport
  stage :header, :body
  required_option :student
  load_html_csv_text

  def setup
    self.data = StudentInterventionsSummary.new(options)
  end

  class HTML < Ruport::Formatter::HTML
    renders :html, :for => StudentInterventionsReport
    build :header do
      num_interventions = pluralize(data.student.interventions.size, "intervention").sub(/^0 /, 'no ')
      output << "#{data.student.fullname} #{"(#{data.student.number})" unless data.student.number.blank?} has #{num_interventions}<br />"
    end

    build :body do
      output << data.to_table(format=:html).to_html.sub('<table>', '<table id="student_interventions_table">')
    end

    def pluralize(count, singular, plural = nil)
      "#{count || 0} " + ((count.to_i == 1) ? singular : (plural || singular.pluralize))
    end
  end

  class Text < Ruport::Formatter
    renders :text, :for => StudentInterventionsReport
    build :header do
      num_interventions = pluralize(data.student.interventions.size, "intervention").sub(/^0 /, 'no ')
      output << "Report Generated at #{Time.now}\n"
      output << "#{data.student.fullname}#{" (#{data.student.number})" unless data.student.number.blank?} has #{num_interventions}.\n\n"
    end

    build :body do
      output << data.to_grouping.to_text(:table_width => 9999)
    end
    def pluralize(count, singular, plural = nil)
      "#{count || 0} " + ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
    end
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StudentInterventionsReport
    build :header do
      add_text "Student Name: #{data.student.fullname}"
      # add_text "Report Generated at #{Time.now}"
      # add_text "#{data.student.fullname} (#{data.student.number}) has #{pluralize(data.student.interventions.size, "intervention").sub(/^0 /, 'no ')}.\n\n"
    end

    build :body do
      ::PDF::Writer::TagAlink.style={:factor=>0.05, :text_color=>Color::RGB::Blue, :draw_line=>false, :line_style=>{:dash=>{:phase=>0, :pattern=>[]}}, :color=>Color::RGB::Blue}
      pdf_writer.font_size = 8
      
      pdf_writer.start_page_numbering(350,10,8,:center,"Page: <PAGENUM>")

      output << render_grouping(data.to_grouping(:pdf), options.to_hash.merge(:formatter => pdf_writer))
      ::PDF::Writer::TagAlink.style=nil
    end
  end
end


class StudentInterventionsSummary
  def initialize(options = {})
    @student = options[:student]
  end

  def to_table(format = nil)
    return unless defined? Ruport

    table = Ruport::Data::Table(["Goal Objective Category", "Intervention", "Description", 'Start Date End Date', 'Frequency Duration', 'Ended By', 'Ended On','Last Updated', 'Tier', 'Participants'])

    # info in model itself dates, frequency, duration.
    # intervention_deftiniion (and parent) info

    # include participants list and designate implementor   -- intervention_people -> users
      # find the relationship inverted in user_interventions_report.rb...

    # included selected monitors and their associated scores.  (groupings involved here)    --intervention_probe_definitions -> [probe_definition, probes]

    # intervention comments -- intervention_comments

    @student.interventions.each do |i|
      table << report_row(i,format)
    end

    return table
  end

   def to_grouping(format = nil)
      tbl = to_table(format = format)
      Ruport::Data::Grouping(tbl, :by => "Goal Objective Category")
   end

  # Accessor to student data for building report header
  def student
    return @student
  end

	private

	def report_row(i,format=nil)
    if [:pdf,:html].include?format
      title_method = :bolded_title
    else
      title_method = :title
    end
	  goal = i.intervention_definition.intervention_cluster.objective_definition.goal_definition.title
	  objective = i.intervention_definition.intervention_cluster.objective_definition.title
	  category = i.intervention_definition.intervention_cluster.title
	  start_date = i.start_date.to_date.to_s(:report)
    end_date = i.end_date.to_date.to_s(:report)

	  ["#{goal} #{objective} #{category}",
  	  i.intervention_definition.send(title_method),
  	  i.intervention_definition.description_with_sld,
  	  "#{start_date} #{end_date}",
  	  "#{i.frequency_summary} #{i.time_length_summary}",
  	  (i.ended_by || User.new).fullname,
  	  i.ended_at,
  	  i.updated_at.to_date.to_s(:report),
  	  i.intervention_definition.tier_summary,
  	  intervention_people(i)
	  ]
	end

	def intervention_people(i)
	  participants = i.intervention_participants.collect do |ip|
	    if ip.role == InterventionParticipant::IMPLEMENTER
	      "*#{ip.user.fullname}*"
	    else
	      ip.user.fullname
	    end
	  end
	  participants.join(" ")
	end
end
