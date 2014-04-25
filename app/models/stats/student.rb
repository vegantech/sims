module Stats::Student
  extend ActiveSupport::Concern
  included do
  scope :with_sims_content, joins("left outer join interventions on interventions.student_id = students.id
  left outer join student_comments on students.id = student_comments.student_id
  left outer join team_consultations on team_consultations.student_id = students.id
  left outer join consultation_form_requests on consultation_form_requests.student_id = students.id"
   ).where("interventions.id is not null or student_comments.id is not null or
                  team_consultations.student_id is not null or consultation_form_requests.student_id is not null")

  scope :with_comments_count, joins("left outer join student_comments on students.id = student_comments.student_id").group("students.id").select("count(student_comments.id) as comments_count")
  scope :with_pending_consultations_count, joins("left outer join team_consultations on students.id = team_consultations.student_id and !team_consultations.draft  and !team_consultations.complete ").group("students.id").select("count(team_consultations.id) as team_consultations_pending_count")



#FIXDATES on first two
  FILTER_HASH_FOR_IN_USE_DATE_RANGE =   {
  created_after: "(interventions.created_at >= ? or student_comments.created_at >= ? or team_consultations.created_at >= ?
    or consultation_form_requests.created_at >=?)",
  created_before: "(interventions.created_at <= ? or student_comments.created_at <= ? or team_consultations.created_at <= ?
    or consultation_form_requests.created_at <=?)"
  }

  define_statistic :students_with_enrollments , count: :all, joins: :enrollments, column_name: 'distinct students.id',
                                                filter_on: {created_after: "enrollments.created_at >= ?", created_before: "enrollments.created_at <= ?"}
  define_statistic :districts_with_enrolled_students , count: :all, joins: :enrollments, column_name: 'distinct students.district_id',
                                                       filter_on: {created_after: "enrollments.created_at >= ?", created_before: "enrollments.created_at <= ?"}
  define_statistic :districts_with_students, count: :all, column_name: 'distinct district_id'

  #TODO DRY THESE
  define_calculated_statistic :students_in_use  do
    stats_in_use.count
  end


  define_calculated_statistic :districts_with_students_in_use  do
    stats_in_use.count("distinct district_id")
  end

  define_calculated_statistic :schools_with_students_in_use  do
    stats_in_use.joins(:enrollments).count("distinct school_id")
  end
  end
end


