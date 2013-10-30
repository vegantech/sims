class StudentSearch
  #This allows me to use it in url_for as a singleton resource
  def self.model_name
    ActiveModel::Name.new(StudentSearch).tap{|s|
      def s.route_key
        "student_search"
      end
    }
  end

  #singleton resource, no param
  def to_param
    nil
  end

  attr_reader :search_hash, :sch_id

  def initialize(search_hash)
    @search_hash = search_hash.symbolize_keys
    @school = search_hash[:school] || School.find_by_id(search_hash[:school_id])
    @sch_id = @school.try(:id) || search_hash[:school_id]
    @user = @search_hash[:user]
  end

  def self.search(search_hash)
    new(search_hash).search
  end

  def search
    @enrollments = @school ? @school.enrollments :  Enrollment.scoped
    restrict_to_user
    grade_and_year
    group_search
    search_type
    last_name
    index_includes
    @enrollments
  end

  private

 def personal_group_search
    if PersonalGroup::TITLE_MATCH.match search_hash[:group_id]
      pg=search_hash.delete(:group_id)[2..-1]
      @enrollments = @enrollments.joins("inner join personal_groups_students on
                                        personal_groups_students.student_id = enrollments.student_id"
                                       ).where({ "personal_groups_students.personal_group_id" => pg})
    end
  end

  def group_search
    personal_group_search
    group_user = search_hash.slice(:user_id, :group_id)
    group_user.delete_if{|k,v| v=='*' || v==''}
    @enrollments = @enrollments.joins "inner join groups_students on groups_students.student_id = enrollments.student_id" if group_user.present?
    @enrollments = @enrollments.where({"groups_students.group_id" => group_user[:group_id]}) if group_user[:group_id]
    @enrollments = @enrollments.joins("inner join user_group_assignments on 
                                      groups_students.group_id = user_group_assignments.group_id"
                                     ).where(
                                     :user_group_assignments=>{:user_id => group_user[:user_id]}) if group_user[:user_id]
  end

  def last_name
    @enrollments = @enrollments.joins(:student).where(["students.last_name like ?", "#{search_hash[:last_name]}%"]) unless search_hash[:last_name].blank?
  end

  def index_includes
    if search_hash.delete(:index_includes)
      ids=@enrollments.pluck(:student_id)
      @enrollments=Student.joins(:enrollments).order('students.last_name, students.first_name').select(
        "students.id, grade, students.district_id, last_name, first_name, number, esl, special_ed, students.updated_at"
      ).where(:id => ids).with_comments_count.with_pending_consultations_count.group("enrollments.id").where("enrollments.school_id" => sch_id)

#this is worse.
#      Enrollment.send(:preload_associations, res,  {:student => [:comments ,{:custom_flags=>:user}, {:interventions => :intervention_definition},
#                      {:flags => :user}, {:ignore_flags=>:user},:team_consultations_pending ]})
    end
  end


  def search_type
    @enrollments = case search_hash[:search_type]
    when 'list_all'
      @enrollments
    when 'flagged_intervention'
      flagged
    when 'active_intervention'
      active_interventions
    when 'no_intervention'
      without_intervention
    else
      Enrollment.where('1=2')
    end
  end

  def flagged
    # only include enrollments for students who have at least one of the intervention types.
    scope =@enrollments.where("exists (select id from flags where flags.student_id = students.id)"
                             ).joins(:student=>:flags)

    flag_types = Array(search_hash[:flagged_intervention_types])

    #TODO rename this to just flag_types, also in controller and view
    categories = flag_types - ['ignored','custom']
    conditions = {}

    conditions["flags.category"] = categories unless categories.blank?

    unless  (flag_types - categories ).blank?
      sti_types=[]
      sti_types << 'IgnoreFlag' if flag_types.include?('ignored')
      sti_types << 'CustomFlag' if flag_types.include?('custom')
      conditions["flags.type"] = sti_types
    else
      scope = scope.where 'not exists (select id from flags as flags2 where flags.category=flags2.category and
        flags2.type="IgnoreFlag" and flags.student_id =flags2.student_id)'
    end
    scope = scope.where conditions
  end


  def active_interventions
    scope=@enrollments.where(
      ["exists (select id from interventions where interventions.student_id = enrollments.student_id and
        interventions.active = ?)",true]).joins(
        {:student=>:interventions})

    unless search_hash[:intervention_group_types].blank?
      scope=scope.joins(
        {:student=>{:interventions=>{:intervention_definition=>
          {:intervention_cluster=>{:objective_definition=>:goal_definition}}}}}).where(
        ["objective_definitions.id in (?)", search_hash[:intervention_group_types]])
    end
    scope
  end

  def without_intervention
     @enrollments.where ["not exists (select id from interventions where interventions.student_id = enrollments.student_id and interventions.active = ?)",true]
  end

  def restrict_to_user
    unless @user.blank? || @user.all_students?
      grades = @school.special_user_groups.where(:user_id => @user).uniq.pluck(:grade)
      unless grades.include? nil  #special user group with nil grade = all students in school
        explicit_group_assignment_sql = @user.groups.where(:school_id => @school).joins(:students).select("students.id").reorder('').to_sql
        @enrollments = @enrollments.where ["grade in (?) or enrollments.student_id in (#{explicit_group_assignment_sql})", grades]
      end
    end
  end

  def grade_and_year
    gy = search_hash.slice(:grade,:year)
    gy[:end_year] = gy.delete(:year) if gy.has_key?(:year)
    gy.delete_if{|k,v| v=='*'}
    gy[:end_year] = nil if gy[:end_year] == ''
    @enrollments = @enrollments.where({enrollments: gy}) unless gy.blank?
  end
end
