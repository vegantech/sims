class NewsCell < Cell::Base
  include  LinksAndAttachmentsHelper, ApplicationHelper,  ActionView::Helpers::AssetTagHelper, ActionView::Helpers::TagHelper, ActionView::Helpers::UrlHelper
  helper_method :links_and_attachments#, :link_to_with_icon, :image_tag
  def index
    @parent=@opts[:parent]
    @user = @opts[:user]
    @can_edit = @opts[:district].administers == @parent if @opts[:district] && @user.authorized_for?('news_items',:write_access)

#    raise @opts.inspect.inspect if @parent == System
  end

end
