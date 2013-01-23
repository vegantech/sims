module JqueryHelper
  def jdom *args
    raw "$('#" + dom_id(*args) + "')"
  end

  def ejsr *args
    raw '"' + escape_javascript(render *args) + '"'
  end
end
