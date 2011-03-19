module InterventionsHelper

  def collection_select_with_css_options(form, select_id, collection, option_value, option_text,css_class,method_for_using_class, opts={},html_opts={})
    ret= form.collection_select(:id, collection, option_value, option_text, opts,html_opts)

    collection.each do |option_item|
      ret.gsub!(/value=\"#{option_item.send(option_value)}\"/, "\\0 class=\"#{css_class}\"") if option_item.send(method_for_using_class)
    end
    ret
  end


  def options_from_collection_for_select_with_css_class(collection, value_method, text_method, css_class,method_for_using_class, opts={})
      ret = options_from_collection_for_select(  collection, value_method, text_method, opts)
      collection.each do |option_item|
        ret.gsub!(/value=\"#{option_item.send(value_method)}\"/, "\\0 class=\"#{css_class}\"") if option_item.send(method_for_using_class)
      end
      ret
  end

  def tiered_intervention_definition_select(intervention_definitions, include_blank=true, selected = nil)

   if  current_district.lock_tier?
     lock_tier = true unless  ( current_district.state_dpi_num == 3269  && intervention_definitions.present? && intervention_definitions.first.objective_definition.title == "Improved Attendance")
   end
   ret=%q{<select id="intervention_definition_id" class="fixed_width" onchange="$('spinnerdefinitions').show();form.onsubmit()" name="intervention_definition[id]">}
    ret += '<option value=""></option>' if include_blank
    c=intervention_definitions.group_by{|e| e.tier.to_s}
    selected = selected.id if selected.present?
    if lock_tier
      d=c.keys.sort[0..(current_student.max_tier.position-1)]
    else
      d=c.keys.sort
    end
    ret << selected.to_s
    d.each do |group|
      ret << '<optgroup label ="' + group + '">'
      ret << options_from_collection_for_select_with_css_class(  c[group], :id, :title,'sld','sld?', :selected => selected) if c[group]
#      ret << options_from_collection_for_select(  c[group], :id, :title, :selected => selected) if c[group]
      ret << '</optgroup>'
    end
    ret << '</select>'
    ret
  end



  def tiered_quicklist(quicklist_items)
    if quicklist_items.blank?
      concat("Quicklist is empty.")
    else
      form_for :quicklist_item,  :url => quicklist_interventions_path do |f|
        concat(f.label(:intervention_definition_id, "Intervention Quicklist "))
        concat('<select id="quicklist_item_intervention_definition_id" onchange="form.submit()" name="quicklist_item[intervention_definition_id]"')
        concat('<option value=""></option>')
        gqi=quicklist_items.sort_by(&:tier).group_by{|q| "#{q.objective_definition} : #{q.tier}"}
        gqi.sort.each do |group,col|
          concat("<optgroup label='#{group}'>")
          concat(options_from_collection_for_select_with_css_class(col, :id, :title,'sld','sld?'))
          concat("</optgroup>")
        end
        concat('</select>')



        #        concat(f.collection_select(:intervention_definition_id, quicklist_items, :id, :title ,{:prompt=>""},:onchange=>"submit()"))

        concat("<noscript>#{ f.submit "Pick from Quicklist"}</noscript>")

      end

    end

  end
end
