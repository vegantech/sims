class FileController < ApplicationController
  skip_before_filter :authorize, only: 'download'
  def download
    unless params['filename'].include?('..')
      send_file(File.join(Rails.root,'file',params['filename']), x_sendfile: true)
    else
      redirect_to root_url, status: 403
    end
  end

end
