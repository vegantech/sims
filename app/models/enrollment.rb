# == Schema Information
# Schema version: 20081227220234
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

  validates_presence_of :grade,:school_id, :student_id

  named_scope :by_student_ids_or_grades, lambda {|student_ids,grades| {:conditions => ["enrollments.student_id in (?) or enrollments.grade in (?)", Array(student_ids),Array(grades)]}}

  named_scope :by_last_name, lambda {|last_name| {:conditions => ["students.last_name like ?","%#{last_name}%"]}}

  named_scope :without_active_interventions,  :conditions=> ["not exists select * from interventions where interventions.student_id = students.id and interventions.active = ?",true]
  def self.search(search_hash = {})
    search_hash.symbolize_keys!

    conditions ={}
    conditions[:grade] = search_hash[:grade] if search_hash[:grade] and search_hash[:grade] != "*"
    
    
   
    includes=[:student]
    

    unless search_hash[:group_id].blank? or search_hash[:group_id] == "*"
      #inner join to only include students with matching groups using the habtm join table
      joins = "inner join groups_students on groups_students.student_id = students.id"
      conditions["groups_students.group_id"] = search_hash[:group_id]
    end
    
    
    
    enrollments=case search_hash[:search_type]
    when 'list_all'
      by_last_name(search_hash[:last_name]).find(:all,:conditions => conditions, :joins=>joins, :include=>includes)
    when 'flagged_intervention'  
      # only include enrollments for students who have at least one of the intervention types.
      enrollments=by_last_name(search_hash[:last_name]).find(:all,:conditions => conditions, :joins=>joins, :include=>includes)
      intervention_types = search_hash[:flagged_intervention_types]
      if intervention_types.blank? # needs a different name?
        enrollments.select{|e| e.student.flags.current.any?}
      else
        enrollments.select do |e|
           e.student.flags.current.find{|flag_name, flags_array| intervention_types.include?(flag_name)}
        end
      end
    when 'active_intervention'
      enrollments=by_last_name(search_hash[:last_name]).find(:all,:conditions => conditions, :joins=>joins, :include=>includes)
      enrollments.select{|e| e.student.interventions.active.any?}
      unless search_hash[:intervention_group_types].blank?
        enrollments = enrollments.select do |e|
          e.student.interventions.active.any?{|i| search_hash[:intervention_group_types].include?(i.send(search_hash[:intervention_group].tableize.singularize).id.to_s)}
        end
      end

    when 'no_intervention'
        without_active_interventions.by_last_name(search_hash[:last_name]).find(:all,:conditions => conditions, :joins=>joins, :include=>includes)
    else
      raise 'Unrecognized search_type'
    end
  end


  def self.student_belonging_to_user?(user)
    #TODO this is probably incredibly slow
    find(all).any? do |e|
      user.authorized_enrollments_for_school(e.school).include?(e)
    end
      
  end

  def self.grades
     find(:all,:select=>"distinct grade").collect(&:grade)
  end
end
