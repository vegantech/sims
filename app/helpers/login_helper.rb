module LoginHelper
  def windows_live_icon
    alt_title = "Windows Live"
    link_to image_tag("WindowsLive-128.png", alt: alt_title, title: alt_title),
            omniauth_authorize_path(resource_name, "windowslive") if windows_live?
  end

  def google_apps_link opts={}
    if google_apps?
      title = opts.fetch(:title, "Sign in with Gmail/Google Apps")
      title = image_tag("Gmail-128.png",alt: title, title: title) if opts[:icon]
      link_to title,
              omniauth_authorize_path(resource_name, "google_apps",
                                      domain: current_district.google_apps_domain),
              class: 'google-oauth'
    end
  end

  def windows_live?(district = current_district)
    defined?(::WINDOWS_LIVE_CONFIG) && district.windows_live?
  end

  def google_apps?(district = current_district)
    district.google_apps?
  end
end
