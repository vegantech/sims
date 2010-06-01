class ActionMailer::Base
DEFAULT_EMAIL="SIMS <sims@simspilot.org>"  
  def from_with_default(input=nil)
    i=input || DEFAULT_EMAIL
    from_without_default(i)
  end
  alias_method_chain :from, :default
end
