

def require_everything_in_app
  Dir.glob(RAILS_ROOT+"/app/**/*.rb").each do |rb|
    require rb.split("app/").last
  end
end

