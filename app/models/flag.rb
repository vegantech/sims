# == Schema Information
# Schema version: 20090623023153
#
# Table name: flags
#
#  id          :integer(4)      not null, primary key
#  category    :string(255)
#  user_id     :integer(4)
#  district_id :integer(4)
#  student_id  :integer(4)
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Flag < ActiveRecord::Base
	ORDERED_TYPE_KEYS = %w{attendance suspension math languagearts gifted ignored custom}

  TYPES = {
      "attendance" => {:icon => "A.gif", :humanize => "Attendance"},
      "suspension" => {:icon=> "B.gif", :humanize => "Behavior" },
      "math" => {:icon => "M.gif", :humanize => "Math"},
      "languagearts" => {:icon => "LA.gif", :humanize => "Language Arts"},
      "gifted" => {:icon=> "lightbulb.png", :humanize => "Gifted/Talented"},
      "ignored" => {:icon => "I.gif", :humanize => "Ignored"},
      "custom" => {:icon => "C.gif", :humanize => "Custom"}
    }
  FLAGTYPES= TYPES.reject{|i,j| i=="custom" || i=="ignored"}

  belongs_to :student, :touch => true
  belongs_to :user
  belongs_to :district
  validates_presence_of :category, :reason, :type
  validates_inclusion_of :category, :in => FLAGTYPES.keys

  acts_as_reportable if defined? Ruport


  named_scope :custom, :conditions=>{:type=>'CustomFlag'}
  named_scope :ignore, :conditions=>{:type=>'IgnoreFlag'}
  named_scope :system, :conditions=>{:type=>'SystemFlag'}

  define_statistic :flags , :count => :all
  define_statistic :students_with_flags , :count => :all,  :select => 'distinct student_id'
  define_statistic :districts_with_flags, :count => :all, :select => 'distinct students.district_id', :joins => :student
  define_statistic :users_with_flags, :count => :all, :select => 'distinct user_id'
  def summary
    "#{reason}- by #{user} on #{created_at}"
  end

  def icon
    TYPES[self.category][:icon]
  end

  def self.summary
    all.collect(&:summary)
  end

  def self.current
    #FIXME doesn't handle ignores
    # all.group_by(&:category)
    all.reject do |f|
      (f[:type] == 'IgnoreFlag') or (f[:type] == 'SystemFlag' and IgnoreFlag.find_by_category_and_student_id(f.category, f.student_id))
    end.group_by(&:category)
  end
end
