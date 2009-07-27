class RecommendationObserver < ActiveRecord::Observer
  def after_create(recommendation)

    contact_coordinator(recommendation)
  end



  private
  def contact_coordinator recommendation
    #HARD CODE FOR MMSD FOR NOW
    if recommendation.send(:request_referral)# && recommendation.school.district.state_id == 3269
      sch = recommendation.school
      case sch.name.upcase
      when  /HIGH$/
        raise 'Ted Szalkowski'
      when /MIDDLE$/
        raise 'Scott Zimmerman'
      when /ELEMENTARY$/
        raise 'Jan Duxstad'
      else
        raise sch.name + ' is unknown'
      end
    end

  end



                                                                                           
  
end
