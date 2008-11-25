class PrincipalOverridesCell < Cell::Base
  def user_requests
    user=@opts[:user] || User.find_by_id(session[:user_id])
    @requests=user.principal_override_requests.count if user
    nil
  end
  def principal_responses
    user=@opts[:user] || User.find_by_id(session[:user_id])
    return false unless user && user.principal?
    @show =true 
    #TODO THIS IS SLOW
    overrides=user.grouped_principal_overrides if @show
    @new_requests=overrides[:pending_requests].size
    @responses=overrides[:principal_responses].size
    nil
  end


end
