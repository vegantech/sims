class PrincipalOverridesCell < Cell::Base
  helper ApplicationHelper
  def user_requests opts
    user=opts[:user]# || User.find_by_id(session[:user_id])
    @requests=user.principal_override_requests.count if user
    render
  end

  def principal_responses opts
    user=opts[:user]# || User.find_by_id(session[:user_id])
    return '' unless user && user.principal?
    @show =true
    #TODO THIS IS SLOW
    overrides=user.grouped_principal_overrides if @show
    @new_requests=overrides[:pending_requests].size
    @responses=overrides[:principal_responses].size
    render
  end
end
