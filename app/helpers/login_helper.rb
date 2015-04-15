module LoginHelper
  def windows_live_icon
    alt_title = "Windows Live"
    link_to image_tag("WindowsLive-128.png", :alt => alt_title, :title => alt_title),
      omniauth_authorize_path(resource_name, "windowslive") if windows_live?
  end

  def google_apps_link opts={}
    if google_apps?
      title = opts.fetch(:title, "Sign in with Gmail/Google Apps")
      title = image_tag("Gmail-128.png",:alt => title, :title => title) if opts[:icon]
      link_to title, google_oauth_path.html_safe, :class => 'google-oauth'
    end
  end

  def windows_live?(district = current_district)
    defined?(::WINDOWS_LIVE_CONFIG) && district.windows_live?
  end

  def google_apps?(district = current_district)
    defined?(::GOOGLE_OAUTH_CONFIG) && district.google_apps?
  end

  def google_oauth_path_without_auth_domain
    omniauth_authorize_path(resource_name, "google_oauth2",
                            :hd => current_district.google_apps_domain,
                            :state => current_district.abbrev,
                           )
  end

  def google_oauth_path
    if ENABLE_SUBDOMAINS
      u = google_oauth_path_without_auth_domain[1..-1]
      root_url(subdomain: 'auth') + u
    else
      google_oauth_path_without_auth_domain
    end
  end
end
