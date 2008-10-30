# == Schema Information
# Schema version: 20081030035908
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

  TYPES={
    "attendance"=>{:icon=>"A.gif",:humanize=>"Attendance"},
    "languagearts"=>{:icon=>"LA.gif",:humanize=>"Language Arts"},
    "math"=>{:icon=>"M.gif",:humanize=>"Math"},
    "suspension"=>{:icon=>"B.gif",:humanize=>"Behavior" },
    "ignored"=>{:icon=>"I.gif", :humanize=>"Ignored"},
    "custom"=>{:icon=>"C.gif",:humanize=>"Custom"}
    }
  FLAGTYPES= TYPES.reject{|i,j| i=="custom" || i=="ignored"}

  belongs_to :student
  belongs_to :user
  belongs_to :district
  validates_presence_of :category, :reason
  validates_inclusion_of :category, :in => FLAGTYPES.keys
  acts_as_reportable if defined? Ruport

  def summary
    "#{reason}- by #{user.fullname} on #{created_at}"
  end
end
