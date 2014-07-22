module Stats::Intervention
  extend ActiveSupport::Concern
  included do
    define_statistic :interventions , count: :all, joins: :student
    define_statistic :students_with_interventions , count: :all,  column_name: 'distinct student_id', joins: :student
    define_statistic :districts_with_interventions, count: :all, column_name: 'distinct district_id', joins: {intervention_definition: {intervention_cluster: {objective_definition: :goal_definition}}}
    define_statistic :users_with_interventions, count: :all, column_name: 'distinct user_id', joins: :user
  end
end
