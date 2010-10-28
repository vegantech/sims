# == Schema Information
# Schema version: 20101027022939
#
# Table name: ext_summaries
#
#  id                       :integer(4)      not null, primary key
#  student_id               :integer(4)
#  HomeLanguage             :string(255)
#  streetAddress            :string(255)
#  cityStateZip             :string(255)
#  mealstatus               :string(255)
#  englishProficiency       :string(255)
#  specialEdStatus          :string(255)
#  disability1              :string(255)
#  disability2              :string(255)
#  singleParent             :boolean(1)
#  raceEthnicity            :string(255)
#  suspensions_in           :integer(4)
#  suspensions_out          :integer(4)
#  years_in_district        :integer(4)
#  school_changes           :integer(4)
#  years_at_current_school  :integer(4)
#  previous_school_name     :string(255)
#  current_attendance_rate  :float
#  previous_attendance_rate :float
#  esl                      :boolean(1)
#  tardies                  :integer(4)
#  created_at               :datetime
#  updated_at               :datetime
#

class ExtSummary < ActiveRecord::Base
  belongs_to :student
end
