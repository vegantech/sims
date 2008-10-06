class Flag < ActiveRecord::Base
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
  validates_inclusion_of :category, :in=> FLAGTYPES.keys
  acts_as_reportable if defined? Ruport

  def summary
    "#{reason}- by #{user.fullname} on #{created_at}"
  end



end
