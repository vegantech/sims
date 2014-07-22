class NewsCell < Cell::Rails
  helper  LinksAndAttachmentsHelper, ApplicationHelper
  def index(opts)
    @parent=opts[:parent]
    @user = opts[:user]
    @can_edit = opts[:district].administers == @parent if opts[:district] && @user && @user.authorized_for?('news_items')
    render
#    raise @opts.inspect.inspect if @parent == System
  end
end
