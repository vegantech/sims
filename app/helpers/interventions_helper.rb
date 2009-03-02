module InterventionsHelper

  def tiered_intervention_definition_select(intervention_definitions, include_blank=true, max_tier=nil)

   ret=%q{<select id="intervention_definition_id" class="fixed_width" onchange="$('spinnerdefinitions').show();form.onsubmit()" name="intervention_definition[id]">}
  
    ret += '<option value=""></option>}' if include_blank
    c=intervention_definitions.group_by{|e| e.tier.to_s}
    if max_tier
      d=(1..max_tier).to_a
    else
      d=c.keys
    end
    d.each do |group|
      ret << '<optgroup label ="' + group + '">'
      ret << options_from_collection_for_select(  c[group], :id, :title) if c[group]
      ret << '</optgroup>'
    end
    ret << '</select>'
    ret  
  end
  
 
end
