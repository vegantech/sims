module CicoSettingsHelper
  def setup_cico_setting(cico_setting)
    cico_setting.cico_expectations << CicoExpectation.new if cico_setting.cico_expectations.blank?
    cico_setting.cico_periods << CicoPeriod.new if cico_setting.cico_periods.blank?
    cico_setting
  end

  def add_cico_expectation_link(f)
    add_object_link 'Add Expectation', 'cico_expectations', :partial => 'cico_settings/cico_expectation', :object => CicoExpectation.new,
      :locals => {:f => f}
  end

  def add_cico_period_link(f)
    add_object_link 'Add Period', 'cico_periods', :partial => 'cico_settings/cico_period', :object => CicoPeriod.new,
      :locals => {:f => f}
  end

#MOVE these to application
  def child_index(obj)
    (obj.new_record? ? (obj.errors.any? ? rand.to_s : "index_to_replace_with_js" ) : nil)
  end

  def add_object_link(name, where, render_options)
    html = render(render_options)

    link_to_function name, %{
      Element.insert('#{where}', #{html.to_json}.replace(/index_to_replace_with_js/g,new Date().getTime()));

    }
  end
end
