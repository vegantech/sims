module InterventionsHelper

  def tiered_intervention_definition_select(intervention_definitions, include_blank=true, selected = nil)

   opts = ""
   opts += content_tag :option,{},:value => "" if include_blank

    c=intervention_definitions.group_by{|e| e.tier.to_s}
    selected = selected.id if selected.present?
    d=c.keys.sort
    opts << selected.to_s
    d.each do |group|
      opts += content_tag(:optgroup, :label => group.to_s) do
        options_from_collection_for_select(  c[group], :id, :title, :selected => selected) if c[group]
      end
    end
   select_tag("intervention_definition_id", opts, :class => "fixed_width",
              :onchange => "$('spinnerdefinitions').show();form.onsubmit()",
              :name => "intervention_definition[id]")
  end



  def tiered_quicklist(quicklist_items)
    if quicklist_items.blank?
      concat("Quicklist is empty.")
    else
      form_tag "/interventions/quicklists" do
        concat(label_tag(:intervention_definition_id, "Intervention Quicklist "))
        options = ""
        options += content_tag :option,{},:value => ""
        gqi=quicklist_items.sort_by(&:tier).group_by{|q| "#{q.objective_definition} : #{q.tier}"}
        gqi.sort.each do |group,col|
          options += content_tag(:optgroup, :label => group.to_s) do
            options_from_collection_for_select(col, :id, :title)
          end
        end
        concat(select_tag("intervention_definition_id",options, :onchange => "form.submit()"))
        concat(content_tag(:noscript, submit_tag("Pick from Quicklist")))
      end
    end

  end
end
