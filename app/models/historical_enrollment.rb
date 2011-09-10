class HistoricalEnrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :district
  belongs_to :school

  #add indexes
  #when student is assigned a district, district_id and start_date should be set [happens on import or create]
  #when student leaves district, end_date should be set


  #when student is assigned a school, school_id, end_year and start_date should be set
  #when student leaves school, end_date should be set
  
 
  #Add to district manually
  #Add to district bulk
  #
  #Remove from district manually
  #remove from district bulk
  #
  #add to school manually
  #add to school bulk
  #
  #remove from school manually
  #remove from school bulk

end
