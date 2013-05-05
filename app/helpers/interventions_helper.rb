module InterventionsHelper

  def tiered_intervention_definition_select(intervention_definitions, include_blank=true)

   opts = ""
   opts += content_tag :option,"",:value => "" if include_blank

    c=intervention_definitions.dropdowns.group_by{|e| e.tier.to_s}
    d=c.keys.sort
    d.each do |group|
      opts << content_tag(:optgroup, :label => h(group.to_s)) do
        options_from_collection_for_select(  c[group], :id, :title, :selected => intervention_definitions.id) if c[group]
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
            options_from_collection_for_select(col, :id, :title)
          end
        end
        concat(select_tag("intervention_definition_id",options.html_safe))
        concat(content_tag(:noscript, submit_tag("Pick from Quicklist")))
      end
    end

  end

  def custom_intervention?
    controller_name == "custom_interventions"
  end

  def custom_intervention_enabled?
    current_user.custom_interventions_enabled?
  end

  def intervention_picker_select(picker)
    select_tag(picker.object_id_field,
               options_from_collection_for_select(
                 picker.dropdowns,:id,:title,picker.try(:id)),
                 {:prompt => "", :class => "fixed_width sim_submit"}
              )
  end
end
