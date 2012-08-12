class CicoStudentDay < ActiveRecord::Base
  belongs_to :cico_school_day
  belongs_to :intervention_probe_assignment


  has_many :cico_period_expectations
  accepts_nested_attributes_for :cico_period_expectations

  delegate :student, :to => :intervention_probe_assignment

  def setup(cico_setting)
    if status == 'Present'
      st = 'No Data'
    else
      st=status
    end
    cico_setting.cico_periods.each do |period|
      cico_setting.cico_expectations.each do |expectation|
        cico_period_expectations.find_by_cico_expectation_id_and_cico_period_id(expectation.id,period.id) || 
          cico_period_expectations.build(:cico_period => period, :cico_expectation => expectation, :status => st)
      end
    end
  end

end
