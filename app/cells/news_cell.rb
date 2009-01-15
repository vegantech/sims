class NewsCell < Cell::Base
  def index
    @parent=@opts[:parent]
    @user = @opts[:user]
    @can_edit = @opts[:district].administers == @parent if @opts[:district] && @user.authorized_for?('news_items',:write_access)
    
#    raise @opts.inspect.inspect if @parent == System
  end
end
