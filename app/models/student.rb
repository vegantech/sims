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

  def self.find_flagged_students(flagtypes=[])
    flagtype=Array(flagtypes)
    stitypes=[]
    custom=flagtype.reject!{|v| v =="custom"}
    ignore=flagtype.reject!{|v| v == "ignored"}
    flagtype.reject!{|v| !Flag::TYPES.keys.include?(v)}

    flagtype=Flag::FLAGTYPES.keys if flagtype.blank?

    stitypes << "CustomFlag" if custom
    stitypes << "IgnoreFlag" if ignore


    if stitypes.any?
      find(:all,:include=>:flags,:conditions=>["type in (?) and flagtype in (?)",stitypes,flagtype])
    else
      find(:all,:include=>:flags,:joins=>"left outer join flags as ig on ig.flagtype=flags.flagtype and ig.type='IgnoreFlag' and ig.person_id=flags.person_id",:conditions=>["ig.flagtype is null and flags.flagtype in (?)",flagtype])
    end
  end
end