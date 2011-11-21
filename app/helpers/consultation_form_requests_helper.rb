module ConsultationFormRequestsHelper
  def hide_or_show_consultation_form(f)
    if show_consultation_form?(f)
      ""
    else
      "display:none"
    end
  end

  def show_consultation_form?(f)
    team=f.object.school_team
    if team.nil? && defined?(@teams)
      team = @teams.first
    end
    f.object.filled_in? || team.nil? || team.assets.blank?
  end

  def show_or_hide_form_onchange()
    team_ids_with_assets = []
    @teams.each { |team| team_ids_with_assets << team.id if team.assets.any? } if defined?(@teams)
    {:onchange =>"show_or_hide_team_consultation_form(this,'[#{team_ids_with_assets.join(',')}]');"}
  end
end
