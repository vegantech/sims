class Student < ActiveRecord::Base
  belongs_to :district
  has_many :checklists
  has_many :enrollments
  has_many :schools, :through=>:enrollments
  has_many :comments, :class_name=>"StudentComment"
  has_many :interventions
  has_many :flags do
    def custom_summary
      custom.collect(&:summary)
    end

    def custom
      find_all_by_type('CustomFlag')
    end
    
    def current
      group_by(&:category)
    end
  end

  #This is duplicated in user
  def fullname 
    first_name.to_s + ' ' + last_name.to_s
  end

  def fullname_last_first
    last_name.to_s + ', ' + first_name.to_s
  end


  def latest_checklist
    checklists.find(:first ,:order => "created_at ASC")
  end

  def checklist_definition
    puts "FIXME once a checklist is assigned to a student, they'll never get the new one"
    return district.checklist_definitions.active_checklist_definition if checklists.empty?
    latest_checklist.checklist_definition_cache
  end

  def max_tier
    puts "FIXME this should probably be stored instead of calculated on the fly"
    2

  end



end
