module CicoSettingsHelper
  def setup_cico_setting(cico_setting)
    cico_setting.cico_expectations << CicoExpectation.new
    cico_setting.cico_periods << CicoPeriod.new
    cico_setting

  end
end
