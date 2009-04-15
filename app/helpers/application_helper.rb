# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def li_link_to_if_authorized(name, options = {}, html_options = {})
    #TODO Test then Refactor!!!     This is a spike.
    if options.is_a?String
      url = options
      url = "/"+url.split("/")[3..-1].join("/")if url.include?("http:") 
      hsh = ::ActionController::Routing::Routes.recognize_path url, :method => :get
    else
      url = url_for(options)
      hsh = ::ActionController::Routing::Routes.recognize_path url
    end

    # hsh = ::ActionController::Routing::Routes.recognize_path url.gsub(/\?.*$/,''), :method=> :get
    ctrl = "#{hsh[:controller]}Controller".camelize.constantize
    grp = 'write_access' if ctrl.write_actions.include?(hsh[:action])
    grp = 'read_access' if ctrl.read_actions.include?(hsh[:action])
    content_tag :li, link_to(name, url, html_options) if current_user.authorized_for?(ctrl.controller_path, grp)
  end

  def breadcrumbs
    s = [link_to('Home', root_path)]
    s << link_to_if_current_or_condition('School Selection', schools_path, session[:school_id])
    s << link_to_if_current_or_condition('Student Search', search_students_path, session[:search])
    s << link_to_if_current_or_condition('Student Selection', students_path, session[:selected_student])
    s << link_to_if_current_or_condition(current_student, student_path(current_student), session[:selected_student]) if session[:selected_student]
    s.compact.join(' -> ')
  end

  def link_to_if_current_or_condition(title, path,conditions=nil)
    link_to_unless_current(title,path) if conditions || path == request.path
  end

  def if_student_selected(session = session)
    if session[:selected_students] && session[:selected_student]
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

  def help_popup(msg)
    content_tag(:span, "?", :class=>"help-question", :onmouseover=>"return overlib('#{escape_javascript(msg)}');", :onmouseout => "return nd();")
  end

  def spinner(suffix = nil)
    image_tag "spinner.gif", :id => "spinner#{suffix}", :style => "display:none"
  end

  def link_to_remote_if(condition, name, options = {}, html_options = {}, *parameters_for_method_reference, &block)
    condition ? link_to_remote_degrades(name, options, html_options ) : name
  end

  def link_to_with_icon(name, url, suffix="")
    ext_match = /\.\w+$/
    ext = (name.match ext_match)
    file = "#{name.split(ext_match).first.gsub(/_/," ")}#{suffix}"
    icon= ext.blank? ? "icon_htm.gif" : "icon_#{ext[0][1..-1]}.gif"
    blank={}
    blank[:target]="_blank" unless url=="#"
    link_to "#{image_tag(icon, :class=>"menu_icon")} #{file}", url, blank
  end

  def plus_minus_li( title, &blk)
    id = title.gsub(/ /, '_')
    concat(content_tag(:li, :class => "plus_minus", :id => "li#{id}") do
      link_to_function(title, "toggle_visibility('ul#{id}'); $('li#{id}').style.listStyleImage =( $('ul#{id}').style.display != 'none' ? \"url('/images/minus-8.png')\" : \"url('/images/plus-8.png')\") ") +
      content_tag(:ul, :id => "ul#{id}") do
        capture(&blk)
      end
    end)
  end

  def spell_check_submit
    hidden_field_tag("spellcheck",nil) + 
    submit_tag("Spellcheck", :name=>"spellcheck",:onclick =>"$('spellcheck').value='Spellcheck'")
  end

  def previous_answers(checklist, answer_definition, &block)
    return if checklist.student.blank?
    if block_given?
      if (answers = checklist.previous_answers_for(answer_definition)).any?
        concat "<div style=\"color:gray\">Previous Answers:</div>", block.binding
        answers.each do |answer|
          concat(capture(answer, &block),block.binding)
        end
      end
    end
  end

  def description(obj, name="Description")
    "<div class='fake_label'>#{name}</div><table class='description'><tr><td>#{obj.description}</td></tr></table>" if obj
  end
end
