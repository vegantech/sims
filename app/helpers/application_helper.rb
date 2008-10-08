# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def link_to_remote_degrades(name, options = {}, html_options = {})
      html_options[:href] = url_for(options[:url]) unless html_options.has_key?(:href)
      link_to_remote(name, options, html_options)
    end

end
