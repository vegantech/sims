#TODO REMOVE THIS after upgrading rails to 3.2.15 or 4
module ActionMailer
  class LogSubscriber < ActiveSupport::LogSubscriber
    def deliver(event)
      recipients = Array.wrap(event.payload[:to]).join(', ')
      info("\nSent mail to #{recipients} (#{event.duration.round(1)}ms)")
      debug(event.payload[:mail])
    end
  end
end
