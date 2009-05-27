# == Schema Information
# Schema version: 20090524185436
#
# Table name: flags
#
#  id          :integer         not null, primary key
#  category    :string(255)
#  user_id     :integer
#  district_id :integer
#  student_id  :integer
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Flag < ActiveRecord::Base
	ORDERED_TYPE_KEYS = %w{attendance languagearts math suspension ignored custom}

  TYPES = {
      "attendance" => {:icon => "A.gif", :humanize => "Attendance"},
      "languagearts" => {:icon => "LA.gif", :humanize => "Language Arts"},
      "math" => {:icon => "M.gif", :humanize => "Math"},
      "suspension" => {:icon=> "B.gif", :humanize => "Behavior" },
      "ignored" => {:icon => "I.gif", :humanize => "Ignored"},
      "custom" => {:icon => "C.gif", :humanize => "Custom"}
    }
  FLAGTYPES= TYPES.reject{|i,j| i=="custom" || i=="ignored"}

  belongs_to :student
  belongs_to :user
  belongs_to :district
  validates_presence_of :category, :reason, :type
  validates_inclusion_of :category, :in => FLAGTYPES.keys

  acts_as_reportable if defined? Ruport


  named_scope :custom, :conditions=>{:type=>'CustomFlag'}
  named_scope :ignore, :conditions=>{:type=>'IgnoreFlag'}
  named_scope :system, :conditions=>{:type=>'SystemFlag'}
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
