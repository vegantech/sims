# == Schema Information
# Schema version: 20101101011500
#
# Table name: team_consultations
#
#  id           :integer(4)      not null, primary key
#  student_id   :integer(4)
#  requestor_id :integer(4)
#  team_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  complete     :boolean(1)
#  draft        :boolean(1)
#

class TeamConsultation < ActiveRecord::Base
  DISTRICT_PARENT = :school_team
  belongs_to :student, touch: true
  belongs_to :requestor, class_name: 'User'
  belongs_to :school_team, foreign_key: 'team_id'
  has_many :consultation_forms, dependent: :destroy
  delegate :district,  to: '(student or return nil)'
  delegate :name,  to: :school_team, prefix: true
  accepts_nested_attributes_for :consultation_forms

  after_create :email_concern_recipient
  after_validation :email_concern_recipient, if: 'draft_changed?', on: :update
  after_destroy :email_concern_recipient_about_withdrawal
  scope :complete, where(complete: true)
  scope :pending, where(complete: false, draft: false)
  scope :draft, where(draft: true)

  scope :pending_for_user, lambda {|user| where(complete: false).where(["(draft = ?) OR (draft = ? AND requestor_id = ?)",false,true,user]) }

  define_statistic :team_consultation_requests , count: :all, joins: :student
  define_statistic :students_with_requests , count: :all,  column_name: 'distinct student_id', joins: :student
  define_statistic :districts_with_requests, count: :all, column_name: 'distinct district_id', joins: :student
  define_statistic :users_with_requests, count: :all, column_name: 'distinct requestor_id', joins: :requestor

  def email_concern_recipient
    if student && requestor && !draft
      TeamReferrals.concern_note_created(self).deliver
    end
  end

  def email_concern_recipient_about_withdrawal
    if student && requestor
      TeamReferrals.concern_note_withdrawn(self).deliver
    end
  end

  def recipients
    if school_team.present?
      User.find_all_by_id(school_team.contact_ids)
    else
      []
    end
  end

  def complete!
    update_attribute(:complete, true)
  end

  def undo_complete!
    update_attribute(:complete, false)
  end
end
