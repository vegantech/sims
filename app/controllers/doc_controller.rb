class DocController < ActionController::Base
  self.cache_store=:file_store, "#{RAILS_ROOT}/public/doc"
  caches_page :index, :district_upload

  def index
  end

  def district_upload
    if params[:id]
      doc=params[:id].gsub(/[^a-zA-Z0-9_]/,"")
      if doc
        @importer = "CSVImporter/#{doc}".classify.pluralize.constantize
        render :action => "district_upload/file_api" and return
      end
    end
  end


end
