# == Schema Information
# Schema version: 20090118224504
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

  def self.search(search_hash)
    search_hash.symbolize_keys!
    #    raise "This is broken, it destroys the scoping via the association proxy"


    sch_id = search_hash[:school_id]
    conditions = search_hash.slice(:school_id)
    
    scope = self.scoped(:conditions => conditions)

    
    
    search_hash.delete(:grade) if search_hash[:grade] == "*"

    if u = search_hash[:user]
      search_hash.delete(:user_id) if search_hash[:user_id] == u.id.to_s || search_hash[:user_id] == "*"
      if u.special_user_groups.all_students_in_school?(sch_id)
        #User has access to everyone in school
      else
        grades = Array(search_hash[:grade])
        user_grades = u.special_user_groups.grades_for_school(sch_id)
        grades ||= user_grades
        grades &= user_grades
        #TODO change this to use group_ids
        student_ids = u.groups.find_all_by_school_id(sch_id).collect(&:student_ids).flatten.uniq
        scope=scope.by_student_ids_or_grades(student_ids,grades)
      end
    end

    scope=scope.scoped(:conditions=>search_hash.slice(:grade))
    scope =scope.scoped :joins => "inner join groups_students on groups_students.student_id = enrollments.student_id", :conditions => {"groups_students.group_id" => search_hash[:group_id]} unless search_hash[:group_id].blank? or search_hash[:group_id] == "*"
    scope= scope.scoped :joins => "inner join groups_students on groups_students.student_id = enrollments.student_id inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id" , :conditions => {:user_group_assignments=>{:user_id => search_hash[:user_id]}}  unless search_hash[:user_id].blank?

    
    scope = scope.scoped :joins=>:student, :conditions => ["students.last_name like ?", "#{search_hash[:last_name]}%"] unless search_hash[:last_name].blank?

    case search_hash[:search_type]
    when 'list_all'
    when 'flagged_intervention'  
      # only include enrollments for students who have at least one of the intervention types.
      scope =scope.scoped :conditions => "exists (select * from flags where flags.student_id = students.id)", :joins => {:student=>:flags}

      #TODO rename this to just flag_types, also in controller and view
      categories = Array(search_hash[:flagged_intervention_types]) - ['ignored','custom']
      conditions = {}

      conditions["flags.category"] = categories unless categories.blank?

      unless  (Array(search_hash[:flagged_intervention_types]) - categories ).blank?
        sti_types=[]
        sti_types << 'IgnoreFlag' if search_hash[:flagged_intervention_types].include?('ignored')
        sti_types << 'CustomFlag' if  search_hash[:flagged_intervention_types].include?('custom')
        conditions["flags.type"] = sti_types
      else
        scope = scope.scoped :conditions => ['not exists (select * from flags as flags2 where flags.category=flags2.category and 
        flags2.type="IgnoreFlag" and flags.student_id =flags2.student_id)', "IgnoreFlag"] 
      end
      scope = scope.scoped :conditions => conditions


    when 'active_intervention'
       scope=scope.scoped :conditions=> ["exists (select * from interventions where interventions.student_id = enrollments.student_id and interventions.active = ?)",true],:joins =>{:student=>:interventions}
      unless search_hash[:intervention_group_types].blank?
        table=search_hash[:intervention_group].tableize
        
        scope=scope.scoped :joins => {:student=>{:interventions=>{:intervention_definition=>{:intervention_cluster=>{:objective_definition=>:goal_definition}}}}},
        :conditions => ["#{table}.id in (?)", search_hash[:intervention_group_types]]

      end

    when 'no_intervention'
      scope = scope.scoped :conditions=> ["not exists (select * from interventions where interventions.student_id = enrollments.student_id and interventions.active = ?)",true]
    else
      raise 'Unrecognized search_type'
    end

    if search_hash.delete(:index_includes)
      ids=scope.collect(&:id)
      Enrollment.find(ids,:include => {:student => [{:custom_flags=>:user}, {:interventions => :intervention_definition}, {:flags => :user}, {:ignore_flags=>:user} ]})
    else

      scope#=scope.scoped #:include => :student
      #.compact
    end

  end



  def self.grades
     find(:all,:select=>"distinct grade").collect(&:grade)
  end
end
