def require_everything_in_app
  Dir.glob(RAILS_ROOT+"/app/**/*.rb").each do |rb|
    e=rb.split("app/").last.split("/",2).last.split(".rb").first
    begin
      e.classify.constantize unless e == "application"
    rescue
      require rb.split("app/").last  unless rb.include?"models/notifications.rb"
    end

  end
end

