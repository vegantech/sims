class DistrictUploadJob
  #include SuckerPunch::Job
  require 'import_csv'

  def async_perform(upload_file, district, email = false)
    ::Spawnling.new do
      perform(upload_file, district, email)
    end

  end


  def perform(upload_file, district, email = false)
    importer = ::ImportCSV.new upload_file, district
    begin
      importer.import
      if email
        ::Notifications.district_upload_results(importer.messages, email.presence || ::UNASSIGNED_EMAIL).deliver
      end
    rescue => e
       Rails.logger.error "Job Exception #{Time.now} #{e.message} #{e.backtrace}"
       Rails.cache.write("#{district.id}_import", "We're sorry, but something went wrong.  We've been notified and will take a look at it shortly.#{::ImportCSV::EOF}")
       Airbrake.notify(e,
         :backtrace => e.backtrace,
         :error_class => "District Upload Error",
         :error_message => "District Upload Error: #{e.message}"
        )

    end
  end

end
