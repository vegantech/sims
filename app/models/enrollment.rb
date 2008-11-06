# == Schema Information
# Schema version: 20081030035908
#
# Table name: enrollments
#
#  id         :integer         not null, primary key
#  school_id  :integer
#  student_id :integer
#  grade      :string(16)
#  created_at :datetime
#  updated_at :datetime
#

class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :school

  def self.search(search_hash = {})
    search_hash.symbolize_keys!
    enrollments = find(:all,:include => :student) #expected to already be scoped through school

    if search_hash[:grade] and search_hash[:grade] != '*'
      enrollments = enrollments.select{|e| e.grade == search_hash[:grade]}
    end

    if search_hash[:last_name] and ! search_hash[:last_name].empty?
      enrollments = enrollments.select{|e| e.student.last_name =~ /^#{search_hash[:last_name]}/i}
    end

    unless search_hash[:group_id].blank? or search_hash[:group_id] == "*"
      enrollments = enrollments.select{|e| e.student.group_ids.include?(search_hash[:group_id].to_i)}
    end

    # session[:search] ||= {}
    # session[:search][:grade] = selected_grade
    # session[:search][:last_name] = selected_last_name
    # session[:search][:search_type] = search_type
    # session[:search][:flagged_interention_types] = intervention_types

    case search_hash[:search_type]
    when 'list_all'
    when 'flagged_intervention'  
      # only include enrollments for students who have at least one of the intervention types.
      intervention_types = search_hash[:flagged_intervention_types]
      if intervention_types.blank? # needs a different name?
        enrollments = enrollments.select{|e| e.student.flags.current.any?}
      else
         enrollments = enrollments.select do |e|
           e.student.flags.current.find{|flag_name, flags_array| intervention_types.include?(flag_name)}
        end
      end
    when 'active_intervention'
      enrollments = enrollments.select{|e| e.student.interventions.active.any?}
      unless search_hash[:intervention_group_types].blank?
        enrollments = enrollments.select do |e|
          e.student.interventions.active.any?{|i| search_hash[:intervention_group_types].include?(i.send(search_hash[:intervention_group].tableize.singularize).id.to_s)}
        end
      end

    when 'no_intervention'
      enrollments=enrollments.reject{|e| e.student.interventions.active.any?}
    else
      raise 'Unrecognized search_type'
    end

    enrollments
  end
end
