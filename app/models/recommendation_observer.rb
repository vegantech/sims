class RecommendationObserver < ActiveRecord::Observer
  def after_save(recommendation)

    contact_coordinator(recommendation)
  end



  private
  def contact_coordinator recommendation
    #HARD CODE FOR MMSD FOR NOW
    if recommendation.school && recommendation.send(:request_referral) && recommendation.school.district.state_dpi_num == 3269
      sch = recommendation.school
      case sch.name.upcase
      when  /HIGH$/
        user_name ='Ted Szalkowski'
        user_email = 'tszalkowski@madison.k12.wi.us'
      when /MIDDLE$/
        user_name ='Scott Zimmerman'
        user_email = 'slzimmerman@madison.k12.wi.us'
      when /ELEMENTARY$/
        user_name ='Jan Duxstad'
        user_email = 'jduxstad@madison.k12.wi.us'
      else
        raise sch.name + ' is unknown'
      end
      Notifications.deliver_special_ed_referral recommendation, user_name, user_email, recommendation.student
    end

  end
                                                


                                                                                           
  
end
