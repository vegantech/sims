module DpiOrMmsdHelper

  def show_checklist_section?
    current_student.checklists.present? || current_district.active_checklist_definition.id.present?
  end

  def show_referral_option?
    %w{mmsd madison}.include?(current_district.abbrev)
  end
end
