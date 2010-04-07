module ReportsHelper
  def subreport_selected(opt)
    if opt == "1"
      yield
    end
  end

  def fix_names(name)
    name.gsub!(/Student Comment/,"Team Note")
    name.gsub!(/Intervention Cluster/,"Intervention Category")
    name
  end
end
