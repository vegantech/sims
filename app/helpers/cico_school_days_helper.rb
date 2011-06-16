module CicoSchoolDaysHelper
  def cico_add_to_total(totals, counts, cico_period_expectation)
    totals[cico_period_expectation.cico_period]+=cico_period_expectation.status.to_i
    totals[cico_period_expectation.cico_expectation]+=cico_period_expectation.status.to_i
    totals[:total]+=cico_period_expectation.status.to_i
    counts[cico_period_expectation.cico_period]+=1
    counts[cico_period_expectation.cico_expectation]+=1
    counts[:total]+=1
  end

  def cico_total totals, counts, cico_setting
    (100.0* totals[:total] / (counts[:total] * cico_setting.points_per_expectation)).round(2)


  end
end
