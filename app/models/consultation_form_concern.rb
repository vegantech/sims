class ConsultationFormConcern < ActiveRecord::Base
  AREAS=['Academics', 'Attendance', 'Behavior', 'Social/Emotional', 
    "Life Stressors", 'Health', "Interactions with peers"]

  FIELD_SIZE='18x3'
  belongs_to :consultation_form

  def area_text
    AREAS[area]
  end
  
end
