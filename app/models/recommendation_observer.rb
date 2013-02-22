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
        user_name ='Noelle Sapiro'
        user_email = 'nrsapiro@madison.k12.wi.us'
      when /MIDDLE$/
        user_name ='Noelle Sapiro'
        user_email = 'nrsapiro@madison.k12.wi.us'
      when *["ALLIS ELEMENTARY", "ELVEHJEM ELEMENTARY", "EMERSON ELEMENTARY", "GLENDALE ELEMENTARY", "GOMPERS ELEMENTARY", "HAWTHORNE ELEMENTARY", "NUESTRO MUNDO ELEMENTARY", "KENNEDY ELEMENTARY", "LAKE VIEW ELEMENTARY", "LAPHAM ELEMENTARY", "LINDBERGH ELEMENTARY", "LOWELL ELEMENTARY", "MARQUETTE ELEMENTARY", "MENDOTA ELEMENTARY", "SANDBURG ELEMENTARY", "SCHENK ELEMENTARY"]
        user_name ='Ted Szalkowski'
        user_email = 'tszalkowski@madison.k12.wi.us'
      when *["CHAVEZ ELEMENTARY", "CRESTWOOD ELEMENTARY", "FALK ELEMENTARY", "FRANKLIN ELEMENTARY", "HUEGEL ELEMENTARY", "LEOPOLD ELEMENTARY", "LINCOLN ELEMENTARY", "MIDVALE ELEMENTARY", "MUIR ELEMENTARY", "OLSON ELEMENTARY", "ORCHARD RIDGE ELEMENTARY", "RANDALL ELEMENTARY", "SHOREWOOD ELEMENTARY", "STEPHENS ELEMENTARY", "THOREAU ELEMENTARY", "VAN HISE ELEMENTARY"]
        user_name = 'James Haessly'
        user_email = "jhaessly@madison.k12.wi.us"
      else
        user_name = 'Unknown School'
        user_email = 'veganbuddy@gmail.com'
      end
      Notifications.special_ed_referral(recommendation, user_name, user_email, recommendation.student).deliver
    end

  end
end
