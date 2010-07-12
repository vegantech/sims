class DocController < ActionController::Base
  self.cache_store=:file_store, "#{RAILS_ROOT}/public/doc"
  caches_page :index, :district_upload

  def index
  end

  def district_upload
    if params[:id]
      doc=params[:id].gsub(/[^a-zA-Z0-9_]/,"")
      if doc=="examples"
        render :action => "district_upload/examples" and return
      else
        #get csv object
        
        render :action => "district_upload/view" and return
      end
    end
  end


end
