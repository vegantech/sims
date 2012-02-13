module ReportsHelper
  def subreport_selected(opt, &block)
    capture(&block) if opt == "1"
  end

  def fix_names(name)
    name.gsub!(/Student Comment/,"Team Note")
    name.gsub!(/Intervention Cluster/,"Intervention Category")
    name
  end
end
