class CicoPeriodExpectation < ActiveRecord::Base
  belongs_to :cico_student_day
  belongs_to :cico_period
  belongs_to :cico_expectation
end
