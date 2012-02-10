# == Schema Information
# Schema version: 20101101011500
#
# Table name: recommendations
#
#  id                           :integer(4)      not null, primary key
#  progress                     :integer(4)
#  recommendation               :integer(4)
#  checklist_id                 :integer(4)
#  user_id                      :integer(4)
#  other                        :text
#  should_advance               :boolean(1)
#  created_at                   :datetime
#  updated_at                   :datetime
#  recommendation_definition_id :integer(4)
#  draft                        :boolean(1)
#  district_id                  :integer(4)
#  tier_id                      :integer(4)
#  student_id                   :integer(4)
#  promoted                     :boolean(1)
#

class Recommendation < ActiveRecord::Base
  belongs_to :checklist
  belongs_to :recommendation_definition
  belongs_to :user
  belongs_to :student
  belongs_to :tier
  belongs_to :district
  has_many :recommendation_answers, :dependent => :destroy


  validates_presence_of :recommendation, :message => "is not indicated", :if =>lambda{|r| !r.draft?}
#  validates_presence_of :checklist_id,
  validates_presence_of :other, :if => lambda{|r|!r.draft? && r.recommendation && RECOMMENDATION[r.recommendation][:require_other]}
  attr_accessor :request_referral, :school

  define_statistic :count, :count => :all,:joins => :student
  define_statistic :count_of_districts, :count => :all, :select => 'distinct students.district_id', :joins => :student
  before_save :mark_promoted_if_needed
  after_initialize :setup_from_checklist_or_definition


   #there's a custom sort for this in the checklist helper
  RECOMMENDATION={
    0=>{:text=>"The student made progress and no longer requires intervention.", :readonly => true},
    1 =>{:text=>"The student is making progress; choose new interventions from the next level; continue to monitor progress.",:promote=>true},
    2 =>{:text=>"The student is making progress; continue the same intervention; continue to monitor progress.",:promote=>false},
    3=>{:text => "The student is not making progress; choose new interventions from the current level; continue to monitor progress.",
      },
    4 => {:text => "The student has not made progress.  Choose new interventions from the next level and continue to monitor progress.",:promote=>true},
    5 => {:text => "The student has not made progress.  Make a referral to special education.",:promote=>true,
          :show_elig => true},
    6 => {:text => "Other", :require_other => true ,:promote=>true}

  }

  STATUS={
          :unknown => "UNKNOWN_STATUS",
          :draft => "Draft, make changes to recommendation and submit.",
          :can_refer => "Referred to Special Ed.",
          :cannot_refer => "Criteria not met (need 3 or above on all questions) for referral.",
          :ineligable_to_refer=> "Impairment Suspected, but eligibility not met.",
          :nonadvancing => "Recommendation submitted, continue working at same tier",
          :passed =>  "Recommendation submitted, next tier is available.",
          :failing_score => "Submitted, did not meet criteria to move to next tier.",
          :optional_checklist => "Optional Checklist Completed."
        }

  def should_promote?
    if RECOMMENDATION[recommendation][:text] == "Other" then
      self.advance_tier
    else
      RECOMMENDATION[recommendation][:promote]
    end
  end

  def status
    if draft?
      STATUS[:draft]
    elsif promoted? and RECOMMENDATION[recommendation][:show_elig]
      STATUS[:can_refer]
    elsif promoted?
      STATUS[:passed]
    elsif !promoted? and RECOMMENDATION[recommendation][:show_elig]
      checklist.fake_edit= checklist == student.checklists.last
      (checklist.blank? || checklist.promoted?) ? STATUS[:ineligable_to_refer] : STATUS[:cannot_refer]
    elsif !promoted? and should_promote?
      checklist.fake_edit = checklist == student.checklists.last if checklist
      STATUS[:failing_score]
    elsif !promoted? and !should_promote?
      STATUS[:nonadvancing]
    else
      return STATUS[:unknown]
    end
  end

  def previous_answers
    @prev_answers ||=RecommendationAnswer.find(:all,:include=>:recommendation,:conditions=>["recommendations.student_id=? and recommendations.id !=? and recommendations.created_at < ?",self.student_id,self.id, self.created_at],:order=>"recommendation_answers.updated_at").group_by{|a| a.recommendation_answer_definition_id}
  end

  def answers
    recommendation_definition.recommendation_answer_definitions.each do |ad|
      self.recommendation_answers.build(:recommendation_answer_definition => ad) unless recommendation_answers.any?{|a| a.recommendation_answer_definition == ad}
    end
    self.recommendation_answers
  end

  def answers=(hsh={})
    hsh.each do |h|
      h=h.last if h.is_a?Array and h.size==2
      h.symbolize_keys!
      if h[:recommendation_answer_definition_id]
        a=self.recommendation_answers.detect{|r| r.recommendation_answer_definition_id == h[:recommendation_answer_definition_id].to_i } ||
          recommendation_answers.build(h)
        a.text=h[:text]
        a.draft=self.draft
      end
    end
  end

  def show_button?(k)
    v = RECOMMENDATION[k]
    !v[:readonly] || self.recommendation == k
  end

  def self.without_checklist
    find(:all, :conditions => "checklist_id is null")
  end

  def self.max_tier
    m=find_all_by_promoted(true).collect(&:tier).compact.max
    if m
      m.district.tiers.find_by_position(1+m.position) || m
    else
      nil
    end
  end

  protected

  def setup_from_checklist_or_definition
    if checklist
      self.recommendation_definition ||= checklist.checklist_definition.recommendation_definition if checklist
      self.district_id ||= checklist.district_id
      self.student_id ||= checklist.student_id
      self.tier_id ||= checklist.from_tier
    else
      self.recommendation_definition=RecommendationDefinition.find_by_active(true)
      self.tier_id ||= self.student.max_tier.id if student
    end
  end

  def request_referral
    @request_referral ||= (should_advance && recommendation == 5)
    @request_referral &&= (recommendation == 5)
  end

  def should_advance
     should_promote? unless recommendation.blank? or self.draft?
  end

  def mark_promoted_if_needed
    if draft?
      self.promoted=false
      return true
    elsif errors.empty? and recommendation and should_promote?
      if checklist
        self.promoted=validate_for_tier_escalation
      else
        self.promoted=true
      end
    end
    true
  end

  def validate_for_tier_escalation
    return true unless checklist
    checklist.score_checklist
    checklist.promoted=checklist.score_results.blank?
    checklist.save
    checklist.promoted
  end

end
