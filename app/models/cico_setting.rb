class CicoSetting < ActiveRecord::Base
  DESCRIPTION = "Enable and setup check-in check-out progress monitors for this school"

  STUDENTS=(1...9).collect{|e| "Student #{e}"} +['Student N']
  EXPECTATIONS=['Expectation 1', 'Expectation 2', 'Expectation N']
  PERIODS=(1..6).collect{|e| "Period #{e}"} + ['Period N']
  DAYSTATUS=["School Out", "No Data", "In School"]
  STUDENTSTATUS=["Absent", "School Out","No Data","Present"]
  EXPECTATIONSTATUS=["0","1","2","N","Absent", "No Data", "School Out"]

  belongs_to :school
  belongs_to :probe_definition
  belongs_to :default_participant, :class_name=>'User'
  has_many :cico_periods
  has_many :cico_expectations
  has_many :cico_school_days do
    def by_date_and_user(date, user)
      (find_by_date(date) || build(:date => date)).setup_for_user_and_school_id(user,proxy_owner.school_id)
    end

  end



  accepts_nested_attributes_for :cico_expectations,
    :allow_destroy => true
  accepts_nested_attributes_for :cico_periods,
    :allow_destroy => true

  scope :enabled, where(:enabled => true)

  delegate :title, :to => :probe_definition

  def expectation_values
    ((0..points_per_expectation).to_a | EXPECTATIONSTATUS[-3..-1]).collect(&:to_s)
  end
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
                ).uniq

  end

  def intervention_probe_assignments(user)
    probe_definition.intervention_probe_assignments.find(:all, :include => {:intervention => [{:student=>:enrollments},:intervention_participants]},
                                                         :conditions => "enrollments.school_id = #{school_id}
                                                         and intervention_participants.user_id = #{user.id}")

  end
end
