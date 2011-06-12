class CicoStudentDay < ActiveRecord::Base
  belongs_to :cico_school_day
  belongs_to :intervention_probe_assignment
end
