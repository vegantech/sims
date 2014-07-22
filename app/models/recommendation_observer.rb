class RecommendationObserver < ActiveRecord::Observer
  def after_save(recommendation)
    contact_coordinator(recommendation)
  end

  private
  def contact_coordinator recommendation
    if recommendation.send(:request_referral) && recommendation.school.try(:school_sp_ed_referral)
      sch_r = recommendation.school.school_sp_ed_referral
      Notifications.special_ed_referral(recommendation, sch_r.name, sch_r.email, recommendation.student).deliver
    end
  end
end
