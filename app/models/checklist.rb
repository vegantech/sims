# == Schema Information
# Schema version: 20090428193630
#
# Table name: checklists
#
#  id                      :integer         not null, primary key
#  checklist_definition_id :integer
#  from_tier               :integer
#  student_id              :integer
#  promoted                :boolean
#  user_id                 :integer
#  is_draft                :boolean         default(TRUE)
#  district_id             :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class Checklist < ActiveRecord::Base
  has_many :answers, :dependent => :destroy 
  belongs_to :checklist_definition, :include => {:question_definitions => {:element_definitions => :answer_definitions}}
  belongs_to :student
  belongs_to :teacher, :class_name => "User", :foreign_key => :user_id  #e xplicitly needed for validation
  belongs_to :district
  belongs_to :tier, :foreign_key => :from_tier
  has_one :recommendation,:dependent => :destroy
  validate :cannot_pass_if_draft
  validates_presence_of :student_id, :user_id, :from_tier

  delegate :recommendation_definition, :to => :checklist_definition
  delegate :recommendation_definition_id, :to => :checklist_definition
  acts_as_reportable if defined? Ruport
  attr_accessor :skip_cache

 STATUS = {
          :unknown => "UNKNOWN_STATUS",
          :draft => "Draft, make changes and submit",
          :missing_rec => "Submitted, but missing recommendation",
          :can_refer => "Referred to Special Ed",
          :cannot_refer => "Criteria not met (need 3 or above on all questions) for referral.",
          :ineligable_to_refer=> "Impairment Suspected, but eligibility not met.",
          :nonadvancing => "Checklist submitted, continue working at same tier",
          :passed =>  "Checklist submitted, met criteria to move to next tier",
          :failing_score => "Checklist submitted, did not meet criteria to move to next tier.",
          :optional_checklist => "Optional Checklist Completed"
        }

#  has_many :answers_with_includes, :class_name => "Answer", 
 # :include => {:answer_definition=>:element_definition}
 attr_accessor :score_results, :deletable, :needs_recommendation, :fake_edit
  @checklist_definition = {}
  def checklist_definition_cache
    return checklist_definition   #
    if @skip_cache then
      checklist_definition
    else
      @checklist_definition[self.checklist_definition_id] ||= checklist_definition
    end
  end

   def status
     @deletable=true
     if is_draft? then
       STATUS[:draft]
     elsif needs_recommendation?
       @needs_recommendation=true
       STATUS[:missing_rec]
     elsif recommendation_definition_id.blank?
       STATUS[:optional_checklist]
     else
       @deletable=false
       recommendation.status
     end
   end

   def pending?
     previous_checklist and (previous_checklist.is_draft? or previous_checklist.needs_recommendation?)
   end

   def missing_checklist_definition?
     checklist_definition.new_record?  || checklist_definition.blank?
   end

  def self.new_from_teacher(teacher)
    checklist = Checklist.new(:teacher => teacher)
    return nil unless checklist.student
    checklist.checklist_definition = checklist.student.checklist_definition
    checklist.tier = checklist.student.max_tier
    checklist.district_id = checklist.student.district_id

    c = checklist.student.checklists.find_by_checklist_definition_id(checklist.checklist_definition_id, :order => "created_at DESC")

    if c
      c.answers.each {|e| checklist.answers.build e.attributes} 
      c.score_checklist if c.show_score?(false)
      checklist.score_results = c.score_results 
    end
    checklist
  end

   def self.new_from_student_and_teacher(student, teacher, 
                                        import_previous_answers = false,
                                        score = false)
     # fixme deprecate this
    returning checklist = Checklist.new(:student => student, :teacher=> teacher ) do
      checklist.checklist_definition = student.checklist_definition
      checklist.from_tier = student.max_tier
      checklist.district_id=student.district_id
#      checklist.checklist_definition.reload  why?
      if import_previous_answers or score
      #c=student.checklists.find(:first,:conditions=>["checklist_definition_id=? and from_tier = ? and teacher_id =? and calendar_id =?", checklist.checklist_definition, checklist.from_tier, checklist.teacher_id, checklist.calendar_id],
#      :order=>"created_at DESC")
      c=student.checklists.find_by_checklist_definition_id(checklist.checklist_definition_id,
      :order=>"created_at DESC")
        c.answers.each {|e| checklist.answers.build e.attributes} if c and import_previous_answers
        c.score_checklist  if c and score and c.show_score?(false)
        checklist.score_results = c.score_results if c and score
      end
    end
  end
    
  def self.new_from_params_and_teacher(params, teacher)

    params[:element_definition] ||=[]
    returning checklist = Checklist.new_from_teacher(teacher) do
      checklist.is_draft=!!params[:save_draft]
      params[:element_definition].each do |element_definition_id, answer|
        element_definition = ElementDefinition.find(element_definition_id)
        if ['scale','decision','applicable'].include?(element_definition.kind)
          checklist.answers.build({:checklist => checklist,
                                    :answer_definition_id => answer.to_i})
        elsif ['comment','sa'].include?(element_definition.kind)
          if answer['text'].any?
            checklist.answers.build({:checklist => checklist, 
                                      :answer_definition_id => answer['id'].to_i, 
                                      :text => answer['text']})
          end
        end
      end
    end
  end


  def score_checklist
    @score_results=Hash.new{|h,k| h[k]={}}
    #for demo purpose, answering the second question will pass the checklist
    if student and student.last_name=="Flag" and student.first_name="Every" and answers.find_by_answer_definition_id(6) then
      self.promoted=true
      return true
    end

    inapplicable_questions=[]
    # all 1-8 must be answered, all 9 must have some content common to all tiers
      checklist_definition_cache.element_definitions.each do |element|
          if element.kind=="scale" and !element_definitions_for_answers.include?(element) then
            @score_results[element.question_definition][element] = "A value must be picked"
          elsif element.kind=="sa" and !element_definitions_for_answers.include?(element) then
            @score_results[element.question_definition][element]= "Text must be entered"
          elsif element.kind == "applicable"
            ad=element.answer_definitions.find_by_value(0).id
            @score_results[element.question_definition][element] = "A value must be picked" if !element_definitions_for_answers.include?(element)
            inapplicable_questions << element.question_definition  if answers.collect(&:answer_definition_id).include?(ad)
          end #if
        end # do

    case from_tier
    when 0,1
      nil
    when 2
        #All question 9 completed (done above),  Questions 1-8 needs an answer of 2 or better
        answers.each do |answer|
          @score_results[answer.answer_definition.element_definition.question_definition][answer.answer_definition.element_definition] = 
            "Need to score 2 or better." if answer.answer_definition.value <"2" and answer.answer_definition.element_definition.kind=="scale"
        end #do
    when 3
        #All question 9 completed (done above),  Questions 1-8 needs an answer of 3 or better
        answers.each do |answer|
          @score_results[answer.answer_definition.element_definition.question_definition][answer.answer_definition.element_definition] =  
            "Need to score 3 or better" if answer.answer_definition.value < "3" and answer.answer_definition.element_definition.kind=="scale"
        end #do
    end # case

    inapplicable_questions.each do |iq|
      @score_results.delete(iq)
    end
    self.promoted = @score_results.blank?
  end #method

  def element_definitions_for_answers
    @edfa||= answers.collect(&:answer_definition).collect(&:element_definition)
  end

  def all_valid?
    valid? and
      valid_list?(answers)
  end

  def save_all!
    save! and
      answers.each(&:save!) #and
  #      update_attributes(:promoted=>(score_checklist))

  end

  def text
    checklist_definition_cache.text
  end

  def directions
    checklist_definition_cache.directions
  end

  def question_definitions
    checklist_definition_cache.question_definitions
  end

  def previous_answers_for(answer_definition)
#    student.checklist_answers_for_student.find_all_by_answer_definition_id(answer_definition.answer_definition_id,:conditions=>["checklists.created_at < ?", created_at], :order=> 'created_at ASC')

    Answer.find(:all,
                :conditions => ['answer_definition_id = ? and checklist_id IN(?) and created_at < ? ',
                                answer_definition.id,
                                student.checklists, created_at ||Time.now],
                :order => 'created_at ASC')
  end

  def previous_answer_for(element_definition)
    recent_checklist = student.checklists.find(:first,:order=>"created_at DESC, id DESC")
    recent_checklist.answers.find_all_by_element_definition(element_definition)[0]  unless recent_checklist.blank?

#   student.checklists.collect(&:answers).flatten.select{|answer| answer.answer_definition.element_definition == element_definition}.sort{|answer| answer.created_at}[0]
  end

  def editable?
    @editable ||= self.is_draft? || self.recommendation.blank? || student.checklists.last == self
  end

  def show_score?(check_previous=true)
    @show_score=false
    if !promoted and recommendation and recommendation.should_advance
      @show_score=true
    elsif check_previous
      prev_chk=previous_checklist
      @show_sore= prev_chk and prev_chk.show_score?
    end
    @show_score
#   @show_score = !promoted and recommendation and recommendation.should_advance? or (check_previous and previous_checklist.show_score?(false) )
  end

  def previous_checklist
    @previous_checklist = Checklist.find_by_user_id(self.student_id, :order=>"created_at DESC",:conditions=>["id <> ? and created_at < ?",self.id || -1, self.created_at || Time.now]) if @previous_checklist.nil? 
    @previous_checklist
  end
 
  def needs_recommendation?
    recommendation.blank?  && recommendation_definition_id && !is_draft?
  end

  private

  def valid_list?(list)
    list.all?(&:valid?)
  end

  def cannot_pass_if_draft
    errors.add(:is_draft,"Checklist was not submitted") if promoted && is_draft?
  end

  def cannot_pass_unless_recommended
    errors.add(:recommendation, "Must have recommendation") if  promoted and  needs_recommendation? 
  end
end
