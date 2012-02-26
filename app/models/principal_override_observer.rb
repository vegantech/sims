class PrincipalOverrideObserver < ActiveRecord::Observer
  def after_create(principal_override)
    Notifications.principal_override_request(principal_override).deliver if principal_override.student.principals.present? && !principal_override.skip_email
  end

  def after_update(principal_override)
    Notifications.principal_override_response(principal_override).deliver if principal_override.send_email and principal_override.teacher.present?
  end


end
