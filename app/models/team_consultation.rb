# == Schema Information
# Schema version: 20090524185436
#
# Table name: team_consultations
#
#  id           :integer         not null, primary key
#  student_id   :integer
#  requestor_id :integer
#  recipient_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class TeamConsultation < ActiveRecord::Base
  
  belongs_to :student
  belongs_to :requestor, :class_name =>'User'
  belongs_to :recipient, :class_name => 'User'
  has_one :consultation_form

  accepts_nested_attributes_for :consultation_form


  after_create :email_concern_recipient
 
  def email_concern_recipient
    if student && requestor
      TeamReferrals.deliver_concern_note_created(self)
    end
  end


  
end
