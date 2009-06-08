# == Schema Information
# Schema version: 20090524185436
#
# Table name: consultation_form_concerns
#
#  id                   :integer         not null, primary key
#  area                 :integer
#  consultation_form_id :integer
#  checked              :boolean
#  strengths            :text
#  concerns             :text
#  recent_changes       :text
#  created_at           :datetime
#  updated_at           :datetime
#

class ConsultationFormConcern < ActiveRecord::Base
  AREAS = ['Reading / Language Arts','Math', 'Attendance', 'Behavior', 'Social/Emotional',
    "Life Stressors", 'Health']

  FIELD_SIZE = '18x3'
  belongs_to :consultation_form

  def area_text
    AREAS[area]
  end
end
