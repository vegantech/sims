module ReportsHelper
  def subreport_selected(opt)
    if opt == "1"
      yield
    end
  end
end