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
    opts = ""
    opts += content_tag :option,{},:value => "" if include_blank
    c=intervention_definitions.group_by{|e| e.tier.to_s}
    selected = selected.id if selected.present?
    d=c.keys.sort
    opts << selected.to_s
    d.each do |group|
      opts << content_tag(:optgroup, :label => group.to_s) do
        options_from_collection_for_select_with_css_class(  c[group], :id, :title,'sld','sld?', :selected => selected) if c[group]
      end
    end
   select_tag("intervention_definition_id", opts.html_safe, :class => "fixed_width sim_submit",
              :name => "intervention_definition[id]")
  end



  def tiered_quicklist(quicklist_items)
    if quicklist_items.blank?
      "Quicklist is empty."
    else
      form_tag "/interventions/quicklists" do
        concat(label_tag(:intervention_definition_id, "Intervention Quicklist "))
        options = ""
        options << content_tag( :option,"",:value => "")
        gqi=quicklist_items.sort_by(&:tier).group_by{|q| "#{q.objective_definition} : #{q.tier}"}
        gqi.sort.each do |group,col|
          options << content_tag(:optgroup, :label => h(group.to_s)) do
            options_from_collection_for_select_with_css_class(col, :id, :title,'sld','sld?')
          end
        end
        concat(select_tag("intervention_definition_id",options.html_safe))
        concat(content_tag(:noscript, submit_tag("Pick from Quicklist")))
      end
    end

  end

  def custom_intervention?
    (params[:custom_intervention] == "true") &&  custom_intervention_enabled?
  end

  def custom_intervention_enabled?
    current_user.custom_interventions_enabled?
  end
end
