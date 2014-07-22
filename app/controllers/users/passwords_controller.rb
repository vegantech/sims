class Users::PasswordsController < Devise::PasswordsController
  before_filter :check_district
  layout 'main'

  def edit
    redirect_to login_url, notice: "Reset password token " + I18n.t("errors.messages.expired") and return false if params['token']
    super
  end

  def update
    if params['user'] && params['user']['password'].blank?
      self.resource ||= User.new
      self.resource.errors.add(:password, "cannot be blank")
      render action: :edit and return
    else
      super
    end
  end

  private
  def check_district
    if current_district.forgot_password? || current_district.key?
      return true
    else
      redirect_to login_url, notice: "This district does not support password recovery.  Contact your LSA for assistance"
      return false
    end
  end
end
