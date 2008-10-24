class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :school

  def self.search(search_hash={})
    enrollments = find(:all,:include => :student) #expected to already be scoped through school

    if search_hash[:grade] and search_hash[:grade] != '*'
      enrollments = enrollments.select{|e| e.grade == search_hash[:grade]}
    end

    if search_hash[:last_name] and ! search_hash[:last_name].empty?
      enrollments = enrollments.select{|e| e.student.last_name =~ /^#{search_hash[:last_name]}/i}
    end

    # session[:search] ||= {}
    # session[:search][:grade] = selected_grade
    # session[:search][:last_name] = selected_last_name
    # session[:search][:search_type] = search_type
    # session[:search][:flagged_interention_types] = intervention_types

    case search_hash[:search_type]
    when 'list_all'
    when 'flagged_intervention'
      intervention_types = search_hash[:flagged_intervention_types]
      enrollments=enrollments.select{|e| e.student.flags.any?}
      # only include enrollments for students who have at least one of the intervention types.
      
      #this doesn't work yet and returns an error if no flag options are selected.
      #It is also incorrectly named?

      #enrollments = enrollments.select do |e|
      #  flags = e.student.flags.current.first
      #  # puts "Found flags: #{flags.class.name}, #{flags.inspect}"
      #  flags and flags.find{|k,v| intervention_types.include?(k)}
      #end
    else
      raise 'Unrecognized search_type'
    end

    enrollments
  end
end
