module InterventionsHelper

  def tiered_intervention_definition_select(intervention_definitions, include_blank=true, selected = nil)

   opts = ""
   opts += content_tag :option,"",:value => "" if include_blank

    c=intervention_definitions.group_by{|e| e.tier.to_s}
    selected = selected.id if selected.present?
    d=c.keys.sort
    opts << selected.to_s
    d.each do |group|
      opts << content_tag(:optgroup, :label => h(group.to_s)) do
        options_from_collection_for_select(  c[group], :id, :title, :selected => selected) if c[group]
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

  def goal_select(goal_picker)
    intervention_dropdown_select(:goal_id, goal_picker.goals,goal_picker)
  end

  def intervention_picker_select(picker)
    select_tag(picker.object_id_field,
               options_from_collection_for_select(
                 picker.dropdowns,:id,:title,picker.try(:id)),
                 {:prompt => "", :class => "fixed_width sim_submit"}
              )


  end

  def intervention_dropdown_select(obj_id,collection,selected_obj)
    select_tag(obj_id,
               options_from_collection_for_select(
                 collection,:id,:title,selected_obj.try(:id)),
                 {:prompt => "", :class => "fixed_width sim_submit"}
              )
  end

  def definition_select
    intervention_dropdown_select(:definition_id, definitions,@intervention_definition)
  end

  def definitions
    @intervention_definitions
  end
end
