class ConsultationFormConcern < ActiveRecord::Base
  AREAS=%w{Academics Attendance Behavior Social/Emotional "Life Stressors" Health "Interactions with peers"}

  belongs_to :consultation_form

  def area_text
    AREAS[area]
  end
  
end
