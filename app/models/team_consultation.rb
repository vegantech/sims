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
