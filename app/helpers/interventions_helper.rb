module InterventionsHelper

  def tiered_intervention_definition_select(intervention_definitions, include_blank=true, selected = nil)

    #current_district.lock_tier?
   lock_tier= current_district.lock_tier?
   ret=%q{<select id="intervention_definition_id" class="fixed_width" onchange="$('spinnerdefinitions').show();form.onsubmit()" name="intervention_definition[id]">}
  
    ret += '<option value=""></option>}' if include_blank
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
      ret << options_from_collection_for_select(  c[group], :id, :title, :selected => selected) if c[group]
      ret << '</optgroup>'
    end
    ret << '</select>'
    ret  
  end
  
 
end
