module BuilderHelper
  def new_probe_definition(pd=ProbeDefinition.new)
#    pd.assets.build if pd.assets.blank?
#    pd.probe_definition_benchmarks.build if pd.probe_definition_benchmarks.blank?
    pd
  end

  def exempt_tiers_box form, popup
    str = ""
    if current_district.lock_tier?
      str += "<p><div class='fake_label'>"
      str += form.check_box(:exempt_tier)
      str += "</div>"
      str += form.label(:exempt_tier, "Available to all tiers", {:class => "checkbox_label_span"})
      str += help_popup(popup)
      str += "</p>"
    end
    str
  end

end
