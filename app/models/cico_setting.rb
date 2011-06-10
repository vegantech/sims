class CicoSetting < ActiveRecord::Base
  DESCRIPTION = "Enable and setup check-in check-out progress monitors for this school"
  belongs_to :school
  belongs_to :probe_definition
  belongs_to :default_participant, :class_name=>'User'
  named_scope :enabled, :conditions => {:enabled => true}

  delegate :title, :to => :probe_definition

  def to_param
    probe_definition_id.to_s
  end

  def self.where_participant(user)
    enabled.find(:all, 
                 :include => :probe_definition,
    :joins => "inner join intervention_probe_assignments ipa on cico_settings.probe_definition_id = ipa.probe_definition_id and ipa.enabled
      inner join interventions i on i.id=ipa.intervention_id
      inner join students s on i.student_id = s.id
      inner join enrollments e on s.id = e.student_id and e.school_id = cico_settings.school_id
      inner join intervention_participants ip on ip.intervention_id = i.id and ip.user_id = #{user.id} 
      "
                )
    
  end




end
