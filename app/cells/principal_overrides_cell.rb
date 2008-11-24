class PrincipalOverridesCell < Cell::Base
  def user_requests
    user=@opts[:user] || User.find_by_id(session[:user_id])
    @requests=user.principal_override_requests.count if user
    nil
  end
  def principal_responses
    @new_requests=0
    @responses=0
    nil
  end


end
