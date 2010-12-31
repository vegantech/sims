require 'railmail'

if config.action_mailer.delivery_method == :railmail
  Railmail.init(config, directory)
end