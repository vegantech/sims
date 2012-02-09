# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def spell_check_button
    button_to_function('Check Spelling', "var f=this.form;var speller = new spellChecker();speller.textInputs=$$('#'+f.id + ' .spell_check');speller.openChecker();") +
      help_popup("If you have any problems with the spell check, please email spell_check_problems@simspilot.org . " )
  end

  def show_whats_new
    ["schools","login", "main"].include? params[:controller] or
      params[:controller]=="students" && params[:action] == "search"
  end

  def li_link_to(name, options = {}, html_options = {}, *rest)
    content_tag :li,(link_to(name,options,html_options) + rest.join(" "))
  end
  def li_link_to_if_authorized(name, options = {}, html_options = {}, *rest)
     r= link_to_if_authorized(name, options, html_options, *rest)
     content_tag :li,((r + rest.join(" ").html_safe).html_safe) if r.present?
  end

  def link_to_if_authorized(name, options = {}, html_options = {}, *rest)
    #TODO Test then Refactor!!!     This is a spike.
   # hsh = ::ActionController::Routing::Routes.recognize_path url.gsub(/\?.*$/,''), :method=> :get
    if options.is_a?String
      url = options
      url = "/"+url.split("/")[3..-1].join("/").split('?').first unless url=~ /^\//
      hsh = ::Rails.application.routes.recognize_path url, :method => :get
    else
      if options[:controller].present?
        #Without a leading / url_for will assume it is in the current namespace
        options[:controller]="/#{options[:controller]}" unless options[:controller][0] =='/'
        options[:action] ||= 'index'
        hsh=options
        url=hsh
      else
        url = url_for(options)
        hsh = ::Rails.application.routes.recognize_path url
      end
    end
    ctrl = "#{hsh[:controller]}Controller".camelize.constantize
    grp = 'write_access' if ctrl.class_eval("@@write_actions").include?(hsh[:action])
    grp = 'read_access' if ctrl.class_eval("@@read_actions").include?(hsh[:action])
    link_to(name, url, html_options) if   current_user.authorized_for?(ctrl.controller_path, grp)
  end

  def link_to_if_present(name, path)
    link_to(name,path) if File.exist?("#{Rails.root}/public/#{path}")
  end


  def breadcrumbs
    s = [link_to('Home', root_path)]
    s << link_to_if_current_or_condition('School Selection', schools_path, session[:school_id])
    s << link_to_if_current_or_condition('Student Search', search_students_path, session[:search])
    s << link_to_if_current_or_condition('Student Selection', students_path, session[:selected_student])
    #357 TODO add a test , if district admin had a student selected breadcrumb breaks when they do a new student
    s << link_to_if_current_or_condition(current_student, student_path(current_student), session[:selected_student]) if session[:selected_student] && !current_student.new_record?
    s.compact.join(' -> ').html_safe
  end

  def link_to_if_current_or_condition(title, path,conditions=nil)
    link_to_unless_current(title,path) if conditions || path == request.path
  end

  def if_student_selected
    if current_student
      yield
    end
  end

  def link_to_remote_degrades(name, options = {}, html_options = {})
    html_options[:href] = url_for(options[:url]) unless html_options.has_key?(:href)
    link_to_remote(name, options, html_options)
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

  def help_popup(msg)
    content_tag(:span, "?", :class=>"help-question", :onmouseover=>"return overlib('#{escape_javascript(msg)}');", :onmouseout => "return nd();").html_safe unless msg.blank?
  end

  def spinner(suffix = nil)
    image_tag "spinner.gif", :id => "spinner#{suffix}", :style => "display:none"
  end

  def link_to_remote_if(condition, name, options = {}, html_options = {},  &block)
    condition ? link_to_remote_degrades(name, options, html_options ) : name
  end

  def link_to_with_icon(name, url, suffix="")
    ext_match = /\.\w+$/
    ext = (name.match ext_match)
    file = "#{name.split(ext_match).first.to_s.gsub(/_/," ")}#{suffix}"
    icon= ext.blank? ? "icon_htm.gif" : "icon_#{ext[0][1..-1].downcase}.gif"
    icon = "icon_htm.gif" unless  File.exist?(File.join(Rails.public_path,"images",icon))
    blank={}
    blank[:target]="_blank" unless url=="#"
    link_to "#{image_tag(icon, :class=>"menu_icon")} #{file}".html_safe, url, blank
  end

  def plus_minus_li( title, &blk)
    id = title.gsub(/ /, '_')
    content = with_output_buffer(&blk)

    content_tag(:li, :class => "plus_minus", :id => "li#{id}") do
      link_to_function(title, "toggle_visibility('ul#{id}'); $('li#{id}').style.listStyleImage =( $('ul#{id}').style.display != 'none' ? \"url('/images/minus-8.png')\" : \"url('/images/plus-8.png')\") ")  +
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
end
