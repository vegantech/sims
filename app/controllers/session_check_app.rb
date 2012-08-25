class SessionCheckApp < ActionController::Metal
  def index
    self.response_body =check
  end

  def check
    result=""
    if params['user_id'].present?
      if params['current_student_id'].present? && (session['selected_student'].to_s != params['current_student_id'].to_s)
        result += "Currently, you cannot select two different students in different windows or tabs.    "
      end
      if session["warden.user.user.key"].blank? || Array(session["warden.user.user.key"][1]).join != params['user_id'].to_s
        result += "You've been logged out or another user is using SIMS in another window or tab."
      end
    end


    if result.present?
      result = "<br />Using multiple windows or tabs can cause errors or misplaced data in SIMS.  If you are seeing this message, you should
      close this window.<br /> " + result
    end
      result
  end
end
