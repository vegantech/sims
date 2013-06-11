module LoginHelper
  def windows_live_icon
    alt_title = "Windows Live"
    link_to image_tag("WindowsLive-128.png", :alt => alt_title, :title => alt_title),
      omniauth_authorize_path(resource_name, "windowslive") if windows_live?
  end

  def google_apps_icon
    alt_title = "Sign in with Gmail/Google Apps"
    if google_apps?
      link_to image_tag("Gmail-128.png",:alt => alt_title, :title => alt_title),
        omniauth_authorize_path(resource_name, "google_apps",
                                :domain => current_district.google_apps_domain)
    end
  end

  def windows_live?(district = current_district)
    defined?(::WINDOWS_LIVE_CONFIG) && district.windows_live?
  end

  def google_apps?(district = current_district)
    district.google_apps?
  end
end
