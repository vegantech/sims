# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def spell_check_button
    submit_tag("Check Spelling", :class =>"spell_check_button", :name => nil) +
      help_popup("If you have any problems with the spell check, please email spell_check_problems@simspilot.org . " )
  end

  def show_whats_new
    ["schools","users/sessions", "users/passwords", "main"].include? params[:controller] or
      params[:controller]=="students" && params[:action] == "search"
  end

  def li_link_to(name, options = {}, html_options = {}, *rest)
    content_tag :li,(link_to(name,options,html_options) + rest.join(" "))
  end

  def li_link_to_if_authorized(name, options = {}, html_options = {}, *rest)
     r= link_to_if_authorized(name, options, html_options, *rest)
     content_tag :li,((r + rest.join(" ").html_safe).html_safe) if r.present?
  end

  def link_to_if_authorized(name, options = {}, html_options = {}, *_rest)
    #TODO Test then Refactor!!!     This is a spike.
   # hsh = ::ActionController::Routing::Routes.recognize_path url.gsub(/\?.*$/,''), :method=> :get
    if options.is_a? String
      url = options
      method = html_options.fetch(:method, :get)
      url = "/"+url.split("/")[3..-1].join("/").split('?').first unless url=~ /^\//
      hsh = ::Rails.application.routes.recognize_path url, :method => method
    else
      if options[:controller].present?
        #Without a leading / url_for will assume it is in the current namespace
        options[:controller]="/#{options[:controller]}" unless options[:controller][0] =='/'
        hsh=options
        url=hsh
      else
        url = url_for(options)
        hsh = ::Rails.application.routes.recognize_path url
      end
    end
    ctrl = "#{hsh[:controller]}_controller".camelize.constantize
    link_to(name, url, html_options) if   current_user.authorized_for?(ctrl.controller_path)
  end

  def link_to_if_present(name, path)
    link_to(name,path) if File.exist?("#{Rails.root}/public/#{path}")
  end

  def if_student_selected
    if current_student
      yield
    end
  end

  def link_to_remote(name, options ={}, html_options = {})
    if options.respond_to?(:keys) && options[:url]
      o2 = options.delete(:url)
      html_options.merge!(options)
      options = o2
    end
    link_to name, options, html_options.merge(:remote => true)
  end

  def render_with_empty(options ={})
    if options[:collection].size >0
      render options
    else
      options[:empty].html_safe
    end
  end

  def yes_or_no(bool)
    if bool
      "Yes"
    else
      "No"
    end
  end

  def help_popup(msg,tag=:span)
     content_tag tag,'?', :class => "help-question", :'data-help' => sanitize_and_js_escape_double_quotes(msg)
  end

  def spinner(suffix = nil)
    image_tag "spinner.gif", :id => "spinner#{suffix}", :style => "display:none", :class => 'spinner'
  end

  def link_to_with_icon(name, url, suffix="")
    return "" if name.blank?
    ext = name.split(".").last.split("?").first
    file = name.split("." + ext).first.to_s.gsub(/_/," ") + suffix
    icon= ext.blank? ? "icon_htm.gif" : "icon_#{ext.downcase}.gif"
    icon = "icon_htm.gif" if  Sims::Application.assets.find_asset(icon).nil?
    blank={}
    blank[:target]="_blank" unless url=="#"
    link_to "#{image_tag(icon, :class=>"menu_icon")} #{file}".html_safe, url, blank
  end

  def plus_minus_li( title, content=nil, &blk)
    id = title.gsub(/ /, '_')
    content ||= with_output_buffer(&blk)

    content_tag(:li, :class => "plus_minus", :id => "li#{id}") do
      link_to(title, "#", :class => "plus_minus") +
      content_tag(:ul, content, :id => "ul#{id}")
    end
  end

  def description(obj, name="Description")
    "<div class='fake_label'>#{name}</div><table class='description'><tr><td>#{obj.description}</td></tr></table>".html_safe if obj
  end

  def labelled_form_for(record_or_name_or_array, *args, &proc)
    @spell_check_fields ||= []

    options = args.extract_options!
    content_tag(:div, :class => 'new_form') do
      content_tag(:div, '',  :id => "global_spell_container", :style => "background-color: #ddd") +
      form_for(record_or_name_or_array, *(args << options.merge(:builder => LabelFormBuilder)), &proc)
    end
  end


  def restrict_to_principals?(student)
    current_district.restrict_free_lunch? && !student.principals.include?(current_user)
  end

  def style_display_none_unless(cond)
    'style="display:none;"'.html_safe unless cond
  end

  def body
    uid = current_user ? current_user.id : nil
    sid = current_student_id
    content_tag :body, "data-user" => uid, "data-student" => sid do
      yield
    end
  end

  def sanitize_and_js_escape_double_quotes(text)
    sanitize(text.gsub(/"/,"&quot"))
  end
end
