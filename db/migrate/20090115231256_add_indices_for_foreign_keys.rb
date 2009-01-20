class AddIndicesForForeignKeys < ActiveRecord::Migration
  def self.up
    add_index :answer_definitions, :element_definition_id

    add_index :answers, :checklist_id
    add_index :answers, :answer_definition_id

    add_index :checklist_definitions, :district_id
    add_index :checklist_definitions, :recommendation_definition_id

    add_index :checklists, :checklist_definition_id
    add_index :checklists, :student_id
    add_index :checklists, :user_id
    add_index :checklists, :district_id

    add_index :districts, :state_id

    add_index :element_definitions, :question_definition_id

    add_index :enrollments, :school_id
    add_index :enrollments, :student_id

    add_index :flag_categories, :district_id

    add_index :flags, :user_id
    add_index :flags, :district_id
    add_index :flags, :student_id

    add_index :goal_definitions, :district_id

    add_index :groups, :school_id

    add_index :groups_students, :student_id
    add_index :groups_students, :group_id

    add_index :intervention_clusters, :objective_definition_id

    add_index :intervention_comments, :intervention_id
    add_index :intervention_comments, :user_id

    add_index :intervention_definitions, :intervention_cluster_id
    add_index :intervention_definitions, :tier_id
    add_index :intervention_definitions, :time_length_id
    add_index :intervention_definitions, :frequency_id
    add_index :intervention_definitions, :user_id
    add_index :intervention_definitions, :school_id

    add_index :intervention_participants, :intervention_id
    add_index :intervention_participants, :user_id

    add_index :intervention_probe_assignments, :intervention_id
    add_index :intervention_probe_assignments, :probe_definition_id
    add_index :intervention_probe_assignments, :frequency_multiplier
    add_index :intervention_probe_assignments, :frequency_id

    add_index :interventions, :user_id
    add_index :interventions, :student_id
    add_index :interventions, :intervention_definition_id
    add_index :interventions, :frequency_id
    add_index :interventions, :frequency_multiplier
    add_index :interventions, :time_length_id
    add_index :interventions, :time_length_number
    add_index :interventions, :ended_by_id

    add_index :news_items, :district_id
    add_index :news_items, :school_id
    add_index :news_items, :state_id
    add_index :news_items, :country_id

    add_index :objective_definitions, :goal_definition_id

    add_index :principal_overrides, :teacher_id
    add_index :principal_overrides, :student_id
    add_index :principal_overrides, :principal_id
    add_index :principal_overrides, :start_tier_id
    add_index :principal_overrides, :end_tier_id

    add_index :probe_definition_benchmarks, :probe_definition_id
    add_index :probe_definition_benchmarks, :benchmark

    add_index :probe_definitions, :user_id
    add_index :probe_definitions, :district_id
    add_index :probe_definitions, :maximum_score
    add_index :probe_definitions, :minimum_score
    add_index :probe_definitions, :school_id

    add_index :probe_questions, :probe_definition_id
    add_index :probe_questions_probes, :probe_id
    add_index :probe_questions_probes, :probe_question_id

    add_index :probes, :district_id
    add_index :probes, :intervention_probe_assignment_id

    add_index :question_definitions, :checklist_definition_id

    add_index :quicklist_items, :school_id
    add_index :quicklist_items, :district_id
    add_index :quicklist_items, :intervention_definition_id

    add_index :recommendation_answer_definitions, :recommendation_definition_id, :name => 'rec_def_id'
    add_index :recommendation_answers, :recommendation_id
    add_index :recommendation_answers, :recommendation_answer_definition_id, :name => 'rec_ans_def_id'

    add_index :recommendation_definitions, :district_id
    add_index :recommendation_definitions, :checklist_definition_id

    add_index :recommendations, :checklist_id
    add_index :recommendations, :user_id
    add_index :recommendations, :recommendation_definition_id
    add_index :recommendations, :district_id
    add_index :recommendations, :tier_id
    add_index :recommendations, :student_id

    add_index :recommended_monitors, :intervention_definition_id
    add_index :recommended_monitors, :probe_definition_id

    add_index :rights, :role_id

    add_index :roles, :district_id

    add_index :roles_users, :role_id
    add_index :roles_users, :user_id

    add_index :schools, :district_id

    add_index :special_user_groups, :user_id
    add_index :special_user_groups, :district_id
    add_index :special_user_groups, :school_id

    add_index :states, :country_id

    add_index :student_comments, :student_id
    add_index :student_comments, :user_id

    add_index :students, :district_id

    add_index :tiers, :district_id

    add_index :user_group_assignments, :user_id
    add_index :user_group_assignments, :group_id

    add_index :user_school_assignments, :school_id
    add_index :user_school_assignments, :user_id

    add_index :users, :district_id
  end

  def self.down
    remove_index :users, :column => :district_id

    remove_index :user_school_assignments, :column => :user_id
    remove_index :user_school_assignments, :column => :school_id

    remove_index :user_group_assignments, :column => :group_id
    remove_index :user_group_assignments, :column => :user_id

    remove_index :tiers, :column => :district_id

    remove_index :students, :column => :district_id

    remove_index :student_comments, :column => :user_id
    remove_index :student_comments, :column => :student_id

    remove_index :states, :column => :country_id

    remove_index :special_user_groups, :column => :school_id
    remove_index :special_user_groups, :column => :district_id
    remove_index :special_user_groups, :column => :user_id

    remove_index :schools, :column => :district_id

    remove_index :roles_users, :column => :user_id
    remove_index :roles_users, :column => :role_id

    remove_index :roles, :column => :district_id

    remove_index :rights, :column => :role_id

    remove_index :recommended_monitors, :column => :probe_definition_id
    remove_index :recommended_monitors, :column => :intervention_definition_id

    remove_index :recommendations, :column => :student_id
    remove_index :recommendations, :column => :tier_id
    remove_index :recommendations, :column => :district_id
    remove_index :recommendations, :column => :recommendation_definition_id
    remove_index :recommendations, :column => :user_id
    remove_index :recommendations, :column => :checklist_id

    remove_index :recommendation_definitions, :column => :checklist_definition_id
    remove_index :recommendation_definitions, :column => :district_id

    remove_index :recommendation_answers, :column => :recommendation_answer_definition_id
    remove_index :recommendation_answers, :column => :recommendation_id
    remove_index :recommendation_answer_definitions, :column => :recommendation_definition_id

    remove_index :quicklist_items, :column => :intervention_definition_id
    remove_index :quicklist_items, :column => :district_id
    remove_index :quicklist_items, :column => :school_id

    remove_index :question_definitions, :column => :checklist_definition_id

    remove_index :probes, :column => :intervention_probe_assignment_id
    remove_index :probes, :column => :district_id

    remove_index :probe_questions_probes, :column => :probe_question_id
    remove_index :probe_questions_probes, :column => :probe_id
    remove_index :probe_questions, :column => :probe_definition_id

    remove_index :probe_definitions, :column => :school_id
    remove_index :probe_definitions, :column => :minimum_score
    remove_index :probe_definitions, :column => :maximum_score
    remove_index :probe_definitions, :column => :district_id
    remove_index :probe_definitions, :column => :user_id

    remove_index :probe_definition_benchmarks, :column => :benchmark
    remove_index :probe_definition_benchmarks, :column => :probe_definition_id

    remove_index :principal_overrides, :column => :end_tier_id
    remove_index :principal_overrides, :column => :start_tier_id
    remove_index :principal_overrides, :column => :principal_id
    remove_index :principal_overrides, :column => :student_id
    remove_index :principal_overrides, :column => :teacher_id

    remove_index :objective_definitions, :column => :goal_definition_id

    remove_index :news_items, :column => :country_id
    remove_index :news_items, :column => :state_id
    remove_index :news_items, :column => :school_id
    remove_index :news_items, :column => :district_id

    remove_index :interventions, :column => :ended_by_id
    remove_index :interventions, :column => :time_length_number
    remove_index :interventions, :column => :time_length_id
    remove_index :interventions, :column => :frequency_multiplier
    remove_index :interventions, :column => :frequency_id
    remove_index :interventions, :column => :intervention_definition_id
    remove_index :interventions, :column => :student_id
    remove_index :interventions, :column => :user_id

    remove_index :intervention_probe_assignments, :column => :frequency_id
    remove_index :intervention_probe_assignments, :column => :frequency_multiplier
    remove_index :intervention_probe_assignments, :column => :probe_definition_id
    remove_index :intervention_probe_assignments, :column => :intervention_id

    remove_index :intervention_participants, :column => :user_id
    remove_index :intervention_participants, :column => :intervention_id

    remove_index :intervention_definitions, :column => :school_id
    remove_index :intervention_definitions, :column => :user_id
    remove_index :intervention_definitions, :column => :frequency_id
    remove_index :intervention_definitions, :column => :time_length_id
    remove_index :intervention_definitions, :column => :tier_id
    remove_index :intervention_definitions, :column => :intervention_cluster_id

    remove_index :intervention_comments, :column => :user_id
    remove_index :intervention_comments, :column => :intervention_id

    remove_index :intervention_clusters, :column => :objective_definition_id

    remove_index :groups_students, :column => :group_id
    remove_index :groups_students, :column => :student_id

    remove_index :groups, :column => :school_id

    remove_index :goal_definitions, :column => :district_id

    remove_index :flags, :column => :student_id
    remove_index :flags, :column => :district_id
    remove_index :flags, :column => :user_id

    remove_index :flag_categories, :column => :district_id

    remove_index :enrollments, :column => :student_id
    remove_index :enrollments, :column => :school_id

    remove_index :element_definitions, :column => :question_definition_id

    remove_index :districts, :column => :state_id

    remove_index :checklists, :column => :district_id
    remove_index :checklists, :column => :user_id
    remove_index :checklists, :column => :student_id
    remove_index :checklists, :column => :checklist_definition_id

    remove_index :checklist_definitions, :column => :recommendation_definition_id
    remove_index :checklist_definitions, :column => :district_id

    remove_index :answers, :column => :answer_definition_id
    remove_index :answers, :column => :checklist_id

    remove_index :answer_definitions, :column => :element_definition_id
  end
end
