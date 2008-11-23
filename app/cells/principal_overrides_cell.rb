class PrincipalOverridesCell < Cell::Base
  def user_requests
    @requests=@opts[:user].principal_override_requests.count if @opts[:user]
    nil
  end
  def principal_responses
    @new_requests=0
    @responses=0
    nil
  end
end
