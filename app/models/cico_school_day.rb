class CicoSchoolDay < ActiveRecord::Base
  belongs_to :cico_setting
  has_many :cico_student_days

  accepts_nested_attributes_for :cico_student_days

  def setup_for_user_and_school_id(user, school_id)
  #remove (from display, not from association) those not associated with user
  #build those associated with user but have no data
  #make sure to preserve those that have data but where user is not a participant

    if status.blank?
      self.status = 'No Data'
    end
    cico_setting.probe_definition.intervention_probe_assignments.find(:all, :include => {:intervention => [{:student=>:enrollments},:intervention_participants]}, 
       :conditions => "enrollments.school_id = #{school_id} 
       and intervention_participants.user_id = #{user.id}").each do |ipa|
      if status == 'In School'
        st= 'No Data'
      else
        st=status
      end
      (cico_student_days.find_by_intervention_probe_assignment_id(ipa.id) || 
       cico_student_days.build(:intervention_probe_assignment => ipa, :status => st))
       end


    self

  end

  def next_date
    #TODO skip weekends or days not in setting
    date.next
  end

  def pretty_date
    date.strftime("%A")
  end

  def previous_date
    #TODO skip weekends or days not in setting
    (self.date - 1.day)
  end
end