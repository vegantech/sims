module Stats::User
  extend ActiveSupport::Concern
  included do
    scope :non_admin, where("username not in ('tbiever', 'district_admin')")

    scope :with_sims_content, joins("left outer join interventions on interventions.user_id = users.id
      left outer join student_comments on users.id = student_comments.user_id
      left outer join team_consultations on team_consultations.requestor_id = users.id
      left outer join consultation_form_requests on consultation_form_requests.requestor_id = users.id"
      ).where("interventions.id is not null or student_comments.id is not null or
        team_consultations.student_id is not null or consultation_form_requests.student_id is not null")

    FILTER_HASH_FOR_IN_USE_DATE_RANGE=
      {
      created_after: "(interventions.created_at >= ? or student_comments.created_at >= ? or team_consultations.created_at >= ?
    or consultation_form_requests.created_at >=?)",
      created_before: "(interventions.created_at <= ? or student_comments.created_at <= ? or team_consultations.created_at <= ?
    or consultation_form_requests.created_at <=?)"
      }

      define_calculated_statistic :users_in_use  do
        stats_in_use(@filters).count
      end

      define_calculated_statistic :districts_with_users_in_use  do
        stats_in_use(@filters).count("distinct district_id")
      end

      define_statistic :user_accounts, count: :all, conditions: "username != 'district_admin'"
  end
end
