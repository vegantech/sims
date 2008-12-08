class NewsCell < Cell::Base
  def index
    @parent=@opts[:parent]
    @can_edit = @opts[:district].administers == @parent if @opts[:district] && session[:user_id]
#    raise @opts.inspect.inspect if @parent == System
  end
end
