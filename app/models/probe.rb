class Probe < ActiveRecord::Base
  belongs_to :intervention_probe_assignment

  #has_many :probe_updates
  #has_many :probe_question_definitions, :through =>probe_updates

  #delegate :something, :to=>'(something_else or return nil)' when optional
  delegate :probe_definition, :to => '(intervention_probe_assignment or return nil)'

  validates_presence_of :score
  validates_numericality_of :score
  validate :score_in_range
  
  def calculate_score


  end

  QUESTIONS_PER_GROUP=10




  protected
  def score_in_range
    unless score.blank? || self.probe_definition.blank?||  self.probe_definition.maximum_score.blank? ||
       self.probe_definition.minimum_score.blank?
      unless  (self.probe_definition.minimum_score..self.probe_definition.maximum_score).include?(score)
      errors.add(:score, "must be between the minimum(#{self.probe_definition.minimum_score})
              and the maximum (#{self.probe_definition.maximum_score})")
      end
    end
  end
end
