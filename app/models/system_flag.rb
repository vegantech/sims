# == Schema Information
# Schema version: 20101101011500
#
# Table name: flags
#
#  id         :integer(4)      not null, primary key
#  category   :string(255)
#  user_id    :integer(4)
#  student_id :integer(4)
#  reason     :text
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SystemFlag < Flag
  CSV_HEADERS = [:district_student_id, :category, :reason]

  def summary
    "#{reason} on #{created_at.to_s(:report)}"
  end


  define_statistic :flags , count: :all, joins: :student
  define_statistic :students_with_flags , count: :all,  column_name: 'distinct student_id', joins: :student
  define_statistic :districts_with_flags, count: :all, column_name: 'distinct students.district_id', joins: :student
  define_statistic :users_with_flags, count: :all, column_name: 'distinct user_id', joins: :student
end
