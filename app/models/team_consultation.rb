# == Schema Information
# Schema version: 20090623023153
#
# Table name: team_consultations
#
#  id           :integer(4)      not null, primary key
#  student_id   :integer(4)
#  requestor_id :integer(4)
#  recipient_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class TeamConsultation < ActiveRecord::Base
  belongs_to :student, :touch => true
  belongs_to :requestor, :class_name =>'User'
  belongs_to :school_team, :foreign_key => 'team_id'
  has_many :consultation_forms, :dependent => :destroy
  
  delegate :district,  :to => '(student or return nil)'
  accepts_nested_attributes_for :consultation_forms

  after_create :email_concern_recipient
  after_destroy :email_concern_recipient_about_withdrawal
  named_scope :complete, :conditions => {:complete=>true}
  named_scope :pending, :conditions => {:complete=>false}

  define_statistic :team_consultation_requests , :count => :all, :joins => :student
  define_statistic :students_with_requests , :count => :all,  :select => 'distinct student_id', :joins => :student
  define_statistic :districts_with_requests, :count => :all, :select => 'distinct district_id', :joins => :student
  define_statistic :users_with_requests, :count => :all, :select => 'distinct requestor_id', :joins => :requestor
  

  def email_concern_recipient
    if student && requestor
      TeamReferrals.deliver_concern_note_created(self)
    end
  end

  def email_concern_recipient_about_withdrawal
    if student && requestor
      TeamReferrals.deliver_concern_note_withdrawn(self)
    end
  end



  def recipients
    User.find_all_by_id(school_team.contact_ids) if school_team.present?
  end

  def complete!
    update_attribute(:complete, true)
  end
end
