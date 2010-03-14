# == Schema Information
# Schema version: 20090623023153
#
# Table name: consultation_form_concerns
#
#  id                   :integer(4)      not null, primary key
#  area                 :integer(4)
#  consultation_form_id :integer(4)
#  strengths            :text
#  concerns             :text
#  recent_changes       :text
#  created_at           :datetime
#  updated_at           :datetime
#

class ConsultationFormConcern < ActiveRecord::Base
  AREAS = ['Reading / Language Arts','Math', 'Attendance', 'Behavior', 'Social/Emotional',
    "Life Stressors", 'Health', 'Other']

  FIELD_SIZE = '18x3'
  belongs_to :consultation_form

  def area_text
    AREAS[area]
  end
end
