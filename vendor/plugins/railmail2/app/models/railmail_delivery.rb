class RailmailDelivery < ActiveRecord::Base
  serialize :recipients
  serialize :from
  serialize :headers
  serialize :raw
  
  def new?
    read_at.nil?
  end
  
  def resend(new_recipients=[])
    new_recipients = [new_recipients].compact.flatten
    self.raw.to = new_recipients unless new_recipients.empty?
    ActionMailer::Base.deliver(self.raw)
    save!
  end
end