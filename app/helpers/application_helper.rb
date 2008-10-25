# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_remote_degrades(name, options = {}, html_options = {})
    html_options[:href] = url_for(options[:url]) unless html_options.has_key?(:href)
    link_to_remote(name, options, html_options)
  end

  def render_with_empty(options ={})
    if options[:collection].size >0
      render options
    else
      options[:empty]
    end
  end

  def yes_or_no(bool)
    if bool
      "Yes"
    else
      "No"
    end
  end

  def spinner(suffix = nil)
    image_tag "spinner.gif", :id => "spinner#{suffix}", :style => "display:none"
  end

  def link_to_remote_if(condition, name, options = {}, html_options = {}, *parameters_for_method_reference, &block)
    condition ? link_to_remote_degrades(name, options, html_options ) : name
  end

  def link_to_with_icon(name, url, suffix="")
    ext_match = /\.\w+$/
    ext = name.match ext_match
    file = name.split(ext_match).first.humanize + suffix
    adp=ActiveRecord::Base.configurations[RAILS_ENV]['adapter']
    url="#" if   (adp == "sqlilte3" ||adp  == "mysql") and (url.to_s.match(/\/files_int\//) || url.to_s.match(/oldweb.madison.k12.wi.us\/m/))
    icon= "icon_#{ext[0][1..-1]}.gif"
    blank={}
    blank[:target]="_blank" unless url=="#"
    link_to "#{image_tag(icon)} #{file}", url, blank
  end


    

end
