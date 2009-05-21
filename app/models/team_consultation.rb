class TeamConsultation < ActiveRecord::Base
  CONCERN_NOTE_RECIPIENT_EMAIL = 'b723176@madison.k12.wi.us'
  CONCERN_NOTE_RECIPIENT_NAME = 'Shawn Balestracci (temporary recipient)'
  
  belongs_to :student
  belongs_to :requestor, :class_name =>'User'
  belongs_to :recipient, :class_name => 'User'


  after_create :email_concern_recipient
 
  def email_concern_recipient
    if student && requestor
      TeamReferrals.deliver_concern_note_created(self)
    end
  end


  
end
