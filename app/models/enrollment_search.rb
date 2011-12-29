# == Schema Information
# Schema version: 20101101011500
#
# Table name: enrollments
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  student_id :integer(4)
#  grade      :string(16)
#  created_at :datetime
#  updated_at :datetime
#  end_year   :integer(4)
#

class EnrollmentSearch 
  KNOWN_KEYS =[:school_id, :year, :grade, :last_name,:user]

  def self.search(enrollment_scope, search_hash)
    search = new(enrollment_scope, search_hash)
    search.result_scope
  end

  def initialize(enrollment_scope, search_hash )
    @scope = enrollment_scope
    @search_hash = search_hash.symbolize_keys!
  end

  def filter_by_user_rights
    #TODO Refactor this more
    if @search_hash[:user].present?
      user = @search_hash[:user]
      @scope = @scope.scoped :joins => :school, :conditions => ["schools.district_id = ? ",  user.district]
      unless user.all_students_in_district
        puts "in filter for user rights"
        all_school_ids = user.special_user_groups.find(:all, :select => 'distinct school_id', :conditions => 'grade is null').collect(&:school_id)
        all_grades = user.special_user_groups.find(:all, :select => 'school_id,grade', :conditions => 'grade is not  null').collect{|e| "(enrollments.school_id = #{e.school_id} and enrollments.grade=#{e.grade})"}
        all_grades = "false" if all_grades.blank?

        
        @scope = @scope.scoped :joins => "left outer join groups_students on enrollments.student_id = groups_students.student_id", 
          :conditions => ["enrollments.school_id in (?) or #{all_grades} or groups_students.group_id in (?)", all_school_ids, user.group_ids]
      else
        puts "all_students_in_district"
        #done if all students in distict
      end


      #all_students in school OR
      #school_id in user.all_students_in_school.school_ids
           
      #all students in grade OR
      #(school_id = schoo11.id and grade = school1.grade) or ... 
      
      #all students in groups OR
      #student_groups.group_id in user.group_ids
    end

  end


  def result_scope
    #What is table?  remove that if it is not used
    #user access where user.all_students_in_school.true, or enrollment.grades in user.special_grades or student.group_ids in user.group_ids 
    filter_by_school
    filter_by_year
    filter_by_grade
    filter_by_last_name
    filter_by_user_rights #:user
    return @scope
    filter_by_group #:group_id
    filter_by_user_group_membership #:user_id
    filter_by_search_type

    if search_hash[:user]
      u = search_hash[:user]
      search_hash.delete(:user_id) if search_hash[:user_id] == "*"
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

    if search_hash[:group_id].to_s =~ /^pg/
      pg=search_hash.delete(:group_id)[2..-1]
      
      scope= scope.scoped :joins => "inner join personal_groups_students on personal_groups_students.student_id = enrollments.student_id", :conditions => { "personal_groups_students.personal_group_id" => pg}
    end

      

    if search_hash[:group_id].blank? or search_hash[:group_id] == "*" or search_hash[:user_id].blank?
      scope =scope.scoped :joins => "inner join groups_students on groups_students.student_id = enrollments.student_id", :conditions => {"groups_students.group_id" => search_hash[:group_id]} unless search_hash[:group_id].blank? or search_hash[:group_id] == "*"

      scope= scope.scoped :joins => "inner join groups_students on groups_students.student_id = enrollments.student_id inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id" , :conditions => {:user_group_assignments=>{:user_id => search_hash[:user_id]}}  unless search_hash[:user_id].blank?
    else  #BOTH A GROUP AND group memebr (different from requestor) selected
      scope= scope.scoped :joins => "inner join groups_students on groups_students.student_id = enrollments.student_id inner join user_group_assignments on groups_students.group_id = user_group_assignments.group_id" , :conditions => {"groups_students.group_id" => search_hash[:group_id],:user_group_assignments=>{:user_id => search_hash[:user_id]}}  

    end

    
    scope = scope.scoped :joins=>:student, :conditions => ["students.last_name like ?", "#{search_hash[:last_name]}%"] unless search_hash[:last_name].blank?

    case search_hash[:search_type]
    when 'list_all'
    when 'flagged_intervention'  
      # only include enrollments for students who have at least one of the intervention types.
      scope =scope.scoped :conditions => "exists (select id from flags where flags.student_id = students.id)", :joins => {:student=>:flags}

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
        scope = scope.scoped :conditions => ['not exists (select id from flags as flags2 where flags.category=flags2.category and 
        flags2.type="IgnoreFlag" and flags.student_id =flags2.student_id)', "IgnoreFlag"] 
      end
      scope = scope.scoped :conditions => conditions


    when 'active_intervention'
       scope=scope.scoped :conditions=> ["exists (select id from interventions where interventions.student_id = enrollments.student_id and interventions.active = ?)",true],:joins =>{:student=>:interventions}
      unless search_hash[:intervention_group_types].blank?
        table=search_hash[:intervention_group].tableize
        
        scope=scope.scoped :joins => {:student=>{:interventions=>{:intervention_definition=>{:intervention_cluster=>{:objective_definition=>:goal_definition}}}}},
        :conditions => ["#{table}.id in (?)", search_hash[:intervention_group_types]]

      end

    when 'no_intervention'
      scope = scope.scoped :conditions=> ["not exists (select id from interventions where interventions.student_id = enrollments.student_id and interventions.active = ?)",true]
    else
      return Enrollment.find_all_by_id(nil)
    end

    if search_hash.delete(:index_includes)
      ids=scope.collect(&:id)
      res=Enrollment.find(ids,:joins => :student, :order => 'students.last_name, students.first_name',
      :select => "students.id, grade, students.district_id, last_name, first_name, number, esl, special_ed, student_id,
      concat('views/status_display/students/',students.id,'-',date_format(students.updated_at,'%Y%m%d%H%i%s' )) as index_cache_key
      ")
#this is worse.
#      Enrollment.send(:preload_associations, res,  {:student => [:comments ,{:custom_flags=>:user}, {:interventions => :intervention_definition},
#                      {:flags => :user}, {:ignore_flags=>:user},:team_consultations_pending ]})
      res
    else

      scope#=scope.scoped #:include => :student
      #.compact
    end
  end

  private

  def filter_by_school
    @scope = @scope.scoped_by_school_id(@search_hash[:school_id]) unless @search_hash[:school_id].blank?
  end
 
  def filter_by_year
    if @search_hash[:year].present? && @search_hash[:year] != '*'
      year = @search_hash[:year].blank? ? nil : @search_hash[:year]
       @scope = @scope.scoped_by_end_year(year)
    end
  end

  def filter_by_grade
    @scope = @scope.scoped_by_grade(@search_hash[:grade]) if @search_hash[:grade].present? && @search_hash[:grade] != '*'
  end

  def filter_by_last_name
    @scope = @scope.scoped :joins=>:student, :conditions => ["students.last_name like ?", "#{@search_hash[:last_name]}%"] unless @search_hash[:last_name].blank?
  end

end
