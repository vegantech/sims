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

  def self.search(search_hash = {})
    search_hash.symbolize_keys!

    scope = self.scoped({:include=>:student})
    scope =scope.scoped :conditions => {:grade=> search_hash[:grade]} if search_hash[:grade] and search_hash[:grade] != "*"
    scope =scope.scoped :joins => "inner join groups_students on groups_students.student_id = students.id", :conditions => {"groups_students.group_id" => search_hash[:group_id]} unless search_hash[:group_id].blank? or search_hash[:group_id] == "*"
    scope = scope.scoped :conditions => ["students.last_name like ?", "%#{search_hash[:last_name]}%"] unless search_hash[:last_name].blank?

    case search_hash[:search_type]
    when 'list_all'
    when 'flagged_intervention'  
      # only include enrollments for students who have at least one of the intervention types.
      #TODO This is any flags at all, ignore flags count as positive flag hits
      scope =scope.scoped :conditions => "exists (select * from flags where flags.student_id = students.id)", :include => {:student=>:flags}

      #TODO rename this to just flag_types, also in controller and view
      # parsed_intervention_types = search_hash[:flagged_intervention_types].reject{|type| type == 'ignored'}
     

      #(a or s or m or la) and (i or c)
      sti_types=[]

      unless  search_hash[:flagged_intervention_types].blank?
        sti_types << 'IgnoreFlag' if search_hash[:flagged_intervention_types].include?('ignored')
        sti_types << 'CustomFlag' if  search_hash[:flagged_intervention_types].include?('custom')
      end
      categories =  Array(search_hash[:flagged_intervention_types]) - ['ignored','custom']
      
      scope= scope.scoped :conditions => {"flags.category" => categories} unless categories.blank?

      scope= scope.scoped :conditions => {"flags.type" => sti_types} unless sti_types.blank?

      unless sti_types.include?('IgnoreFlag')
        scope = scope.scoped :conditions => ['flags.type != ? and not exists (select * from flags as flags2 where flags.category=flags2.category and 
        flags2.type="IgnoreFlag" and flags.student_id =flags2.student_id)', "IgnoreFlag"] 
      end

    when 'active_intervention'
       scope=scope.scoped :conditions=> ["exists (select * from interventions where interventions.student_id = students.id and interventions.active = ?)",true],:include =>{:student=>:interventions}
      unless search_hash[:intervention_group_types].blank?
        #        scope = scope.scoped :conditions =>  ... ,
        #:includes => {:intervention=>{:intervention_definition=>{:intervention_cluster=>{:objective_definition=>:goal_definition}}}}
        # with_active_interventions_by_groups(search_hash[:intervention_group], search_hash[:intervention_group_types])
        enrollments = scope.select do |e|
          #12/29/08 Don't think this can be much better, it filters the above by selected flags, note that the intervention group
          #is dynamic and a call on the model
          e.student.interventions.active.any?{|i| search_hash[:intervention_group_types].include?(i.send(search_hash[:intervention_group].tableize.singularize).id.to_s)}
        end
      end

    when 'no_intervention'
      scope = scope.scoped :conditions=> ["not exists (select * from interventions where interventions.student_id = students.id and interventions.active = ?)",true]
    else
      raise 'Unrecognized search_type'
    end
    scope
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
