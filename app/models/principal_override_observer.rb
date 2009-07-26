class PrincipalOverrideObserver < ActiveRecord::Observer
  def after_create(principal_override)
    Notifications.deliver_principal_override_request(principal_override) if principal_override.student.principals.present?
  end

  def after_update(principal_override)
    Notifications.deliver_principal_override_response(principal_override) if principal_override.send_email
  end


end
