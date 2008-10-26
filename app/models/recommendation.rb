class Recommendation < ActiveRecord::Base
  belongs_to :checklist
  validates_presence_of :recommendation, :message => "is not indicated"
  validates_presence_of :reason, :if=>lambda{|r| RECOMMENDATION[r.recommendation][:promote]}
  validates_presence_of :checklist_id
  validates_presence_of :other, :if => lambda{|r| RECOMMENDATION[r.recommendation][:require_other]}
  attr_accessor :request_referral
  attr_accessor :other

  RECOMMENDATION={
    0=>{:text=>"The student made progress and no longer requires intervention."},
    2 =>{:text=>"The student is making progress; choose new interventions from the next level to accelerate progress or address additional needs; continue to monitor progress.",:promote=>true},
    3=>{:text => "The student has not made progress.  Choose new interventions from the current level and continue to monitor progress."},
    4 => {:text => "The student has not made progress.  Choose new interventions from the next level and continue to monitor progress.",:promote=>true},
    5 => {:text => "The student has not made progress and multiple attempts at intervention have been tried.  Make a referral to special education.",:promote=>true,
          :show_elig => true},
    6 => {:text => "Other", :require_other => true ,:promote=>true}
  
  }

  



  def set_reason_from_previous!
    st_list=Checklist::STATUS
    st=checklist.previous_checklist.status unless checklist.previous_checklist.blank?

    if st && [st_list[:cannot_refer],
      st_list[:ineligable_to_refer],
      st_list[:failing_score]].include?(st)
      self.reason ||= checklist.previous_checklist.recommendation.reason
    end
    self.reason
  end


  protected

  def request_referral
    @request_referral ||= (should_advance && recommendation == 5)
  end

  def before_save
    if errors.empty? and RECOMMENDATION[recommendation][:promote]
      self.should_advance=true
      self.should_advance = request_referral if recommendation.to_i==5
    end
  end

  def after_save
    if self.should_advance?
      validate_for_tier_escalation
    end
  end

  def validate_for_tier_escalation
    checklist.score_checklist
    checklist.promoted=checklist.score_results.blank?
    checklist.save
  end

end
