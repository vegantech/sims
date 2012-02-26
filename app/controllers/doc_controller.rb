class DocController < ActionController::Base
  helper :application
  def self.page_cache_directory
  "#{Rails.root}/public/doc"
  end

#  caches_page :index, :district_upload
  require File.expand_path 'lib/csv_importer/base_system_flags'

  def index
  end

  def district_upload
    if params[:id]
      doc=params[:id].gsub(/[^a-zA-Z0-9_]/,"")
      if doc
        @importer = "CSVImporter/#{doc}".classify.pluralize.constantize
        render :action => "doc/district_upload/file_api" and return
      end
    end
  end


end
