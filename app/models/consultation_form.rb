# == Schema Information
# Schema version: 20101101011500
#
# Table name: consultation_forms
#
#  id                   :integer(4)      not null, primary key
#  user_id              :integer(4)
#  team_consultation_id :integer(4)
#  do_differently       :text
#  parent_notified      :text
#  not_in_sims          :text
#  desired_outcome      :text
#  created_at           :datetime
#  updated_at           :datetime
#  student_id           :integer(4)
#  race_culture         :text
#

class ConsultationForm < ActiveRecord::Base
  include LinkAndAttachmentAssets
  belongs_to :user
  belongs_to :team_consultation
  
  has_many :consultation_form_concerns, :dependent => :destroy
  delegate :district,  :to => '(team_consultation or return nil)'
  delegate :school_team,  :to => '(team_consultation or return nil)'
  attr_writer :school, :student


  define_statistic :consultation_forms , :count => :all, :joins => {:team_consultation => :student}
  define_statistic :students_with_forms , :count => :all,  :select => 'distinct team_consultations.student_id', :joins => {:team_consultation=>:student}
  define_statistic :districts_with_forms, :count => :all, :select => 'distinct district_id', :joins => :user
  define_statistic :users_with_forms, :count => :all, :select => 'distinct user_id',:joins => :user

  accepts_nested_attributes_for :consultation_form_concerns
  before_save :set_team_consultation, :set_user

  FIELD_SIZE = '60x3'

  def build_concerns
     0.upto(ConsultationFormConcern::AREAS.length() -1 ){|i| consultation_form_concerns.build(:area => i)} if consultation_form_concerns.blank?
  end

 private
  def set_team_consultation
    if @student.present? && @school.present?
      self.team_consultation = @student.team_consultations.pending(:joins=>:school_teams,:conditions=>{:school_teams=>{:school_id=>@school.id}}).first
    end
  end

  def set_user
    if user_id.nil? and team_consultation.present?
      self.user_id = team_consultation.requestor_id
    end
  end
  
end
