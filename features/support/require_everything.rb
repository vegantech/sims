

def require_everything_in_app
  puts "Skipping models/notifications treetop prevents classes derived from ActionMailer::Base from loading"
  Dir.glob(RAILS_ROOT+"/app/**/*.rb").each do |rb|
    require rb.split("app/").last  unless rb.include?"models/notifications.rb"

  end
end

