class CicoStudentDay < ActiveRecord::Base
  belongs_to :cico_school_day
  belongs_to :intervention_probe_assignment

  has_many :period_expectations

  delegate :student, :to => :intervention_probe_assignment

end
