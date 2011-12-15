module ConsultationFormRequestsHelper
  def hide_or_show_consultation_form(f)
    if show_consultation_form?(f)
      ""
    else
      "display:none"
    end
  end

  def show_consultation_form?(f)
    return true unless current_district.show_team_consultation_attachments?
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

  def team_consultation_form(team_consultation)
    html_options = {:multipart => true, :target =>"upload_frame"}

    unless team_consultation.new_record?
      html_options[:method]  = :put
      url = team_consultation_path(team_consultation,:format =>:js)
    else
      url = team_consultations_path(:format =>:js)
    end

    form_for(team_consultation, :url => url, :html => html_options) do |f|
      yield f
    end
  end
end
