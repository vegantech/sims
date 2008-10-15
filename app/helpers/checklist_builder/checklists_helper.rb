module ChecklistBuilder::ChecklistsHelper

  BLIND_DOWN_TIME = 0.25
  BLIND_UP_TIME = 0.25
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

  # Below are our standard JS helpers

  # When you have links that are highlighted, if they are clicked in quick succession the
  # start color becomes whatever the current color of the highlight is, and therefore the
  # end color.  This prevents this behavior.
  def safe_highlight(dom_id)
    page << "if(!Element.hasClassName('#{dom_id}','disabled_for_highlight')){"
    page << "Element.addClassName('#{dom_id}','disabled_for_highlight')"
    page.visual_effect :highlight, "#{dom_id}"
    page.delay(1) do
      page << "Element.removeClassName('#{dom_id}','disabled_for_highlight')"
    end
    page << "}"
  end

  # Returns the javascript necessary to check for visibility.
  def if_visible(dom_id)
    "if (Element.visible('#{dom_id}')){"
  end

  # Returns the javascript necessary to check if an element is not visible.
  def if_not_visible(dom_id)
    "if (!Element.visible('#{dom_id}')){"
  end

  # Changes the content of a link and safely highlights it.  Remember to use a span in the link
  # for the "drifting" theme.
  def change_link(dom_id, new_text)
    page.update_content(dom_id, new_text)
  end

  # Replaces the partial with an updated copy and highlights it to reflect the change
  def update_content(dom_id, *options_for_render)
    page.replace_html dom_id, *options_for_render
    page.safe_highlight dom_id
  end

  # Inserts content into the given dom_id then blinds_down
  def insert_content(dom_id, *options_for_render)
    page.replace_html dom_id, *options_for_render
    page.blind_down dom_id
  end

  # Blinds up and removes the content
  def remove_content(dom_id, options={})
    options[:duration] ||= BLIND_UP_TIME
    page.blind_up dom_id, options
    page.delay(options[:duration]) do
      page.replace_html dom_id, ""
    end
  end

  # Does blind_down with standard options
  def blind_down(dom_id, options={})
    options[:duration] ||= BLIND_DOWN_TIME
    page.visual_effect :blind_down, dom_id, options
  end

  # Does blind_up with standard options
  def blind_up(dom_id, options={})
    options[:duration] ||= BLIND_UP_TIME
    page.visual_effect :blind_up, dom_id, options
  end

  # Removes the content if it is visible
  def remove_content_if_visible(dom_id)
    page << if_visible(dom_id)
    page.remove_content dom_id
    page << "}"
  end

  # Removes the content and changes the link if the content is visible
  def remove_content_and_change_link_if_visible(content_dom_id, link_dom_id, link_text)
    page << if_visible(content_dom_id)
    page.remove_content content_dom_id
    page.change_link link_dom_id, link_text
    page << "}"
  end

  # Inserts or updates error content
  def insert_or_update_error_content(dom_id, error_messages)
    page << if_visible(dom_id)
    page.update_content dom_id, error_messages
    page << "}else{"
    page.insert_content dom_id, error_messages
    page << "}"
  end

  def link_to_add_attachment(object)
    link_to 'Add Attachment', {:controller=>"attachment",:action=>:new,
    :class=>object.class, :id=>object} ,{:method=>:post} if object.respond_to?"attachments"
  end

  def link_to_add_link(object)
    link_to 'Add Link', {:controller=>"link",:action=>:new,
    :class=>object.class, :id=>object} ,{:method=>:post} if object.respond_to?"links"
  end

  def list_links_and_attachments_with_delete(object)
    list_links_and_attachments(object,true)
  end

  def list_links_and_attachments(object,do_delete=false)
    list_attachments(object,do_delete).to_s +
    list_links(object,do_delete).to_s
  end

  def list_links_with_delete(object)
    list_links(object,true)
  end

  def list_links(object, do_delete=false)
    #attendance_probe=""
    #    attendance_probe = content_tag 'li', link_to('Calculate Rate', {:action=>'attendance_rate',

    #:controller=>'main'},{:target=>'_blank'}) if object.respond_to?(:title) && object.title.to_s.downcase.match(/attendance rate/) &&  ActiveRecord::Base.configurations[RAILS_ENV]['adapter']  == "sqlserver" 
    content_tag :ul, render(:partial=>"link/link",:collection=>object.links, :locals=>{:delete=>do_delete}) if object.respond_to?(
                                                                "links") and object.links.size>0
  end

  def list_attachments_with_delete(object)
    list_attachments(object,true)
  end

  def all_objective_definition_attachments(tier=1)
    ObjectiveDefinition.all_attachments(tier)
  end
    
  def list_attachments(object, do_delete=false)
    if object.respond_to?:size
      collection=object
    else
      collection=object.attachments if object.respond_to?( "attachments")
    end
    collection=Array(collection)
    
    content_tag :ul, render(:partial=>"attachment/attachment", :collection=>collection, :locals=>{:delete=>do_delete}) if collection.size >0
  end

  def link_to_remote_degrades(name, options = {}, html_options = {})
    html_options[:href] = url_for(options[:url]) unless html_options.has_key?(:href)
    link_to_remote(name, options, html_options)
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

  def breadcrumb(contr, action)
    select_group = link_to "Find student", {:controller=>"main", :action => school_selection_action}
    student_list = "#{select_group} -> #{link_to "Student Selection", {:controller=>"main",:action=>"student_selection"} if session[:calendarID]} -> "
    student_profile = "#{student_list} #{link_to "Student Profile", {:controller=>"student_profile",:action=>"student_profile"} if session[:selected_students]} -> "
    intervention = "#{student_profile}"
    intervention = "#{student_profile} #{link_to "Student Intervention", {:controller => "intervention", :action=>"view",:id=>@intervention}} ->" unless @interventions

    crumb="<br />"
    if contr=="main"
      #      if action =~ /school_selection/
      #        crumb=nil
      #      end
      #      if action =~ /grade_selection/
      #        crumb=nil #"Choose a grade and/or section."
      #      end

      if action == "student_selection"
        crumb = "#{select_group} -> "
      end

      if action == "student_selection_of_parent_or_guardian"
        crumb = " Next, select the students you want to work with."
      end
    end

    if contr=="student_profile"

      if action == "student_profile"
        crumb = "#{student_list}"
      end

      if action == "student_profile_by_parent"
        crumb = "#{link_to "Select Students", {:controller=>"main", :action => "student_selection_of_parent_or_guardian"}} ->"
      end


    end
    if contr == "intervention"
      #      unless action == "add_intervention"
      crumb = "#{student_profile}"
      #      end
    end

    if contr == "intervention_monitor"
      if action == "edit"
        crumb = "#{intervention}"
      end
    end

    if contr == "intervention_person"
      @intervention ||=@intervention_person.intervention
      crumb = "#{student_profile} #{link_to "View Intervention and Progress Monitor", {:controller => "intervention", :action=>"view",:id=>@intervention}} ->"
    end

    if contr == "intervention_definition"
      crumb = "#{student_profile} Custom Intervention"
    end

    if contr == "checklists"
      crumb = "#{student_profile}"
    end

    if contr == "recommendations"
      crumb = "#{student_profile} #{link_to "Checklist for #{@checklist.student.fullname_first_last}", {:controller => "checklists", :action=>"view",:id=>@checklist}}"
    end
    if contr== "reports"
      crumb = "#{student_profile}"
    end

    crumb
  end

  def school_selection_action
    # if authorized_for({:controller=>"main",:action=>"school_selection"})
    if authorized_for({:controller=>"main", :action=>"school_selection_by_district"})
      "school_selection_by_district"
    elsif  authorized_for({:controller=>"main",:action=>"school_selection"})
      "school_selection"
    end
  end

  def toggle_plus_minus text, effect, div
    plus_id="#{div}_toggle_plus_span"
    minus_id="#{div}_toggle_minus_span"
    plus=content_tag(:span, "+", :id=>plus_id, :style=>"display:inline:" )
    minus = content_tag(:span, "-", :id=>minus_id, :style=>"display:none")
    link_to_function "#{text}#{plus}#{minus}",
    "#{visual_effect(effect, div)}toggle_visibility(&quot;#{plus_id}&quot;);toggle_visibility(&quot;#{minus_id}&quot;)"
  end

  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options), block.binding)
  end

  def plus_minus_li(title, effecttype,divname, options = {}, &block)
    block_to_partial('shared/plus_minus_li', options.merge!(:title=>title,:effecttype=>effecttype,:divname=>divname),&block)
  end


  unless defined?BlueCloth
    def markdown(text)
      h(text) 
    end

    def markdown_note
      ""
    end

  else
    def markdown_note  
     link_to "You can use markdown","http://www.deveiate.org/projects/BlueCloth/wiki/AboutMarkdown",:target=>"_blank"
    end
  end
 
    def markdown_with_span(text)
       content_tag :span, markdown(text),:class=>'markdown'
    end
end
