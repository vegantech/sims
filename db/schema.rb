# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120119221044) do

  create_table "answer_definitions", :force => true do |t|
    t.integer  "element_definition_id"
    t.text     "text"
    t.string   "value"
    t.integer  "position"
    t.boolean  "autoset_others"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_definitions", ["element_definition_id"], :name => "index_answer_definitions_on_element_definition_id"

  create_table "answers", :force => true do |t|
    t.integer  "checklist_id"
    t.integer  "answer_definition_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["answer_definition_id"], :name => "index_answers_on_answer_definition_id"
  add_index "answers", ["checklist_id"], :name => "index_answers_on_checklist_id"

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  add_index "assets", ["attachable_id", "attachable_type"], :name => "index_assets_on_attachable_id_and_attachable_type"

  create_table "checklist_definitions", :force => true do |t|
    t.text     "text"
    t.text     "directions"
    t.boolean  "active"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recommendation_definition_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  add_index "checklist_definitions", ["district_id"], :name => "index_checklist_definitions_on_district_id"
  add_index "checklist_definitions", ["recommendation_definition_id"], :name => "index_checklist_definitions_on_recommendation_definition_id"

  create_table "checklists", :force => true do |t|
    t.integer  "checklist_definition_id"
    t.integer  "from_tier"
    t.integer  "student_id"
    t.boolean  "promoted"
    t.integer  "user_id"
    t.boolean  "is_draft",                :default => true
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklists", ["checklist_definition_id"], :name => "index_checklists_on_checklist_definition_id"
  add_index "checklists", ["district_id"], :name => "index_checklists_on_district_id"
  add_index "checklists", ["student_id"], :name => "index_checklists_on_student_id"
  add_index "checklists", ["user_id"], :name => "index_checklists_on_user_id"

  create_table "consultation_form_concerns", :force => true do |t|
    t.integer  "area"
    t.integer  "consultation_form_id"
    t.text     "strengths"
    t.text     "concerns"
    t.text     "recent_changes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultation_form_requests", :force => true do |t|
    t.integer  "student_id"
    t.integer  "requestor_id"
    t.integer  "team_id"
    t.boolean  "all_student_scheduled_staff"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultation_forms", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_consultation_id"
    t.text     "do_differently"
    t.text     "parent_notified"
    t.text     "not_in_sims"
    t.text     "desired_outcome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.text     "race_culture"
  end

  add_index "consultation_forms", ["team_consultation_id"], :name => "index_consultation_forms_on_team_consultation_id"

  create_table "district_logs", :force => true do |t|
    t.integer  "district_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "district_logs", ["district_id", "created_at"], :name => "index_district_logs_on_district_id_and_created_at"
  add_index "district_logs", ["district_id", "user_id"], :name => "index_district_logs_on_district_id_and_user_id"

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.integer  "state_dpi_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                 :default => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "marked_state_goal_ids"
    t.string   "key",                   :default => ""
    t.string   "previous_key",          :default => ""
    t.boolean  "lock_tier",             :default => false, :null => false
    t.boolean  "restrict_free_lunch",   :default => true
  end

  add_index "districts", ["abbrev"], :name => "index_districts_on_abbrev"

  create_table "element_definitions", :force => true do |t|
    t.integer  "question_definition_id"
    t.text     "text"
    t.string   "kind"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "element_definitions", ["question_definition_id"], :name => "index_element_definitions_on_question_definition_id"

  create_table "enrollments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "student_id"
    t.string   "grade",      :limit => 16
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "end_year"
  end

  add_index "enrollments", ["school_id"], :name => "index_enrollments_on_school_id"
  add_index "enrollments", ["student_id"], :name => "index_enrollments_on_student_id"

  create_table "ext_adult_contacts", :force => true do |t|
    t.integer  "student_id"
    t.string   "relationship"
    t.boolean  "guardian"
    t.string   "firstName"
    t.string   "lastName"
    t.string   "homePhone"
    t.string   "workPhone"
    t.string   "cellPhone"
    t.string   "pager"
    t.string   "email"
    t.string   "streetAddress"
    t.string   "cityStateZip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ext_adult_contacts", ["student_id"], :name => "index_ext_adult_contacts_on_student_id"

  create_table "ext_arbitraries", :force => true do |t|
    t.integer  "student_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ext_arbitraries", ["student_id"], :name => "index_ext_arbitraries_on_student_id"

  create_table "ext_siblings", :force => true do |t|
    t.integer  "student_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "student_number"
    t.string   "grade"
    t.string   "school_name"
    t.integer  "age"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ext_siblings", ["student_id"], :name => "index_ext_siblings_on_student_id"

  create_table "ext_summaries", :force => true do |t|
    t.integer  "student_id"
    t.string   "HomeLanguage"
    t.string   "streetAddress"
    t.string   "cityStateZip"
    t.string   "mealstatus"
    t.string   "englishProficiency"
    t.string   "specialEdStatus"
    t.string   "disability1"
    t.string   "disability2"
    t.boolean  "singleParent"
    t.string   "raceEthnicity"
    t.integer  "suspensions_in"
    t.integer  "suspensions_out"
    t.integer  "years_in_district"
    t.integer  "school_changes"
    t.integer  "years_at_current_school"
    t.string   "previous_school_name"
    t.float    "current_attendance_rate"
    t.float    "previous_attendance_rate"
    t.boolean  "esl"
    t.integer  "tardies"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ext_summaries", ["student_id"], :name => "index_ext_summaries_on_student_id"

  create_table "ext_test_scores", :force => true do |t|
    t.integer  "student_id"
    t.string   "name"
    t.date     "date"
    t.float    "scaleScore"
    t.string   "result"
    t.date     "enddate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ext_test_scores", ["student_id"], :name => "index_ext_test_scores_on_student_id"

  create_table "flag_categories", :force => true do |t|
    t.integer  "district_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "threshold",   :default => 100
  end

  add_index "flag_categories", ["district_id"], :name => "index_flag_categories_on_district_id"

  create_table "flag_descriptions", :force => true do |t|
    t.integer  "district_id"
    t.text     "languagearts"
    t.text     "math"
    t.text     "suspension"
    t.text     "attendance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "gifted"
    t.text     "science"
    t.text     "socialstudies"
  end

  add_index "flag_descriptions", ["district_id"], :name => "index_flag_descriptions_on_district_id"

  create_table "flags", :force => true do |t|
    t.string   "category",   :limit => 15, :null => false
    t.integer  "user_id"
    t.integer  "student_id"
    t.text     "reason"
    t.string   "type",       :limit => 10, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["student_id"], :name => "index_flags_on_student_id"
  add_index "flags", ["type"], :name => "index_flags_on_type"
  add_index "flags", ["user_id"], :name => "index_flags_on_user_id"

  create_table "frequencies", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goal_definitions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "district_id"
    t.integer  "position"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exempt_tier", :default => false, :null => false
  end

  add_index "goal_definitions", ["district_id"], :name => "index_goal_definitions_on_district_id"

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "district_group_id", :limit => 20, :default => "", :null => false
  end

  add_index "groups", ["district_group_id"], :name => "index_groups_on_id_district"
  add_index "groups", ["school_id"], :name => "index_groups_on_school_id"

  create_table "groups_students", :id => false, :force => true do |t|
    t.integer "student_id"
    t.integer "group_id"
  end

  add_index "groups_students", ["group_id"], :name => "index_groups_students_on_group_id"
  add_index "groups_students", ["student_id"], :name => "index_groups_students_on_student_id"

  create_table "intervention_clusters", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "objective_definition_id"
    t.integer  "position"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exempt_tier",             :default => false, :null => false
  end

  add_index "intervention_clusters", ["objective_definition_id"], :name => "index_intervention_clusters_on_objective_definition_id"

  create_table "intervention_comments", :force => true do |t|
    t.integer  "intervention_id"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "intervention_comments", ["intervention_id"], :name => "index_intervention_comments_on_intervention_id"
  add_index "intervention_comments", ["user_id"], :name => "index_intervention_comments_on_user_id"

  create_table "intervention_definitions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "custom",                  :default => false
    t.integer  "intervention_cluster_id"
    t.integer  "tier_id"
    t.integer  "time_length_id"
    t.integer  "time_length_num",         :default => 1
    t.integer  "frequency_id"
    t.integer  "frequency_multiplier",    :default => 1
    t.integer  "user_id"
    t.integer  "school_id"
    t.boolean  "disabled",                :default => false, :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notify_email"
    t.boolean  "exempt_tier",             :default => false, :null => false
  end

  add_index "intervention_definitions", ["frequency_id"], :name => "index_intervention_definitions_on_frequency_id"
  add_index "intervention_definitions", ["intervention_cluster_id"], :name => "index_intervention_definitions_on_intervention_cluster_id"
  add_index "intervention_definitions", ["school_id"], :name => "index_intervention_definitions_on_school_id"
  add_index "intervention_definitions", ["tier_id"], :name => "index_intervention_definitions_on_tier_id"
  add_index "intervention_definitions", ["time_length_id"], :name => "index_intervention_definitions_on_time_length_id"
  add_index "intervention_definitions", ["user_id"], :name => "index_intervention_definitions_on_user_id"

  create_table "intervention_participants", :force => true do |t|
    t.integer  "intervention_id"
    t.integer  "user_id"
    t.integer  "role",            :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "intervention_participants", ["intervention_id"], :name => "index_intervention_participants_on_intervention_id"
  add_index "intervention_participants", ["user_id"], :name => "index_intervention_participants_on_user_id"

  create_table "intervention_probe_assignments", :force => true do |t|
    t.integer  "intervention_id"
    t.integer  "probe_definition_id"
    t.integer  "frequency_multiplier"
    t.integer  "frequency_id"
    t.date     "first_date"
    t.date     "end_date"
    t.boolean  "enabled",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal"
  end

  add_index "intervention_probe_assignments", ["frequency_id"], :name => "index_intervention_probe_assignments_on_frequency_id"
  add_index "intervention_probe_assignments", ["frequency_multiplier"], :name => "index_intervention_probe_assignments_on_frequency_multiplier"
  add_index "intervention_probe_assignments", ["intervention_id"], :name => "index_intervention_probe_assignments_on_intervention_id"
  add_index "intervention_probe_assignments", ["probe_definition_id"], :name => "index_intervention_probe_assignments_on_probe_definition_id"

  create_table "interventions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "student_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "intervention_definition_id"
    t.integer  "frequency_id"
    t.integer  "frequency_multiplier"
    t.integer  "time_length_id"
    t.integer  "time_length_number"
    t.boolean  "active",                     :default => true
    t.integer  "ended_by_id"
    t.date     "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "end_reason"
    t.boolean  "fidelity"
  end

  add_index "interventions", ["ended_by_id"], :name => "index_interventions_on_ended_by_id"
  add_index "interventions", ["frequency_id"], :name => "index_interventions_on_frequency_id"
  add_index "interventions", ["frequency_multiplier"], :name => "index_interventions_on_frequency_multiplier"
  add_index "interventions", ["intervention_definition_id"], :name => "index_interventions_on_intervention_definition_id"
  add_index "interventions", ["student_id"], :name => "index_interventions_on_student_id"
  add_index "interventions", ["time_length_id"], :name => "index_interventions_on_time_length_id"
  add_index "interventions", ["time_length_number"], :name => "index_interventions_on_time_length_number"
  add_index "interventions", ["user_id"], :name => "index_interventions_on_user_id"

  create_table "news_items", :force => true do |t|
    t.text     "text"
    t.boolean  "system"
    t.integer  "district_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_items", ["district_id"], :name => "index_news_items_on_district_id"
  add_index "news_items", ["school_id"], :name => "index_news_items_on_school_id"
  add_index "news_items", ["system"], :name => "index_news_items_on_system"

  create_table "objective_definitions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "goal_definition_id"
    t.integer  "position"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exempt_tier",        :default => false, :null => false
  end

  add_index "objective_definitions", ["goal_definition_id"], :name => "index_objective_definitions_on_goal_definition_id"

  create_table "personal_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "personal_groups", ["user_id", "school_id"], :name => "index_personal_groups_on_user_id_and_school_id"

  create_table "personal_groups_students", :id => false, :force => true do |t|
    t.integer "personal_group_id", :null => false
    t.integer "student_id",        :null => false
  end

  add_index "personal_groups_students", ["personal_group_id", "student_id"], :name => "personal_groups_habtm_index", :unique => true

  create_table "principal_override_reasons", :force => true do |t|
    t.integer  "district_id"
    t.text     "reason"
    t.boolean  "autopromote", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "principal_overrides", :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "student_id"
    t.integer  "principal_id"
    t.integer  "status",                             :default => 0
    t.integer  "start_tier_id"
    t.integer  "end_tier_id"
    t.string   "principal_response", :limit => 1024
    t.string   "teacher_request",    :limit => 1024
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "principal_overrides", ["end_tier_id"], :name => "index_principal_overrides_on_end_tier_id"
  add_index "principal_overrides", ["principal_id"], :name => "index_principal_overrides_on_principal_id"
  add_index "principal_overrides", ["start_tier_id"], :name => "index_principal_overrides_on_start_tier_id"
  add_index "principal_overrides", ["student_id"], :name => "index_principal_overrides_on_student_id"
  add_index "principal_overrides", ["teacher_id"], :name => "index_principal_overrides_on_teacher_id"

  create_table "probe_definition_benchmarks", :force => true do |t|
    t.integer  "probe_definition_id"
    t.integer  "benchmark"
    t.string   "grade_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "probe_definition_benchmarks", ["benchmark"], :name => "index_probe_definition_benchmarks_on_benchmark"
  add_index "probe_definition_benchmarks", ["probe_definition_id"], :name => "index_probe_definition_benchmarks_on_probe_definition_id"

  create_table "probe_definitions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "district_id"
    t.boolean  "active",        :default => true
    t.integer  "maximum_score"
    t.integer  "minimum_score"
    t.integer  "school_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "custom",        :default => false, :null => false
  end

  add_index "probe_definitions", ["district_id"], :name => "index_probe_definitions_on_district_id"
  add_index "probe_definitions", ["maximum_score"], :name => "index_probe_definitions_on_maximum_score"
  add_index "probe_definitions", ["minimum_score"], :name => "index_probe_definitions_on_minimum_score"
  add_index "probe_definitions", ["school_id"], :name => "index_probe_definitions_on_school_id"
  add_index "probe_definitions", ["user_id"], :name => "index_probe_definitions_on_user_id"

  create_table "probe_questions", :force => true do |t|
    t.integer  "probe_definition_id"
    t.integer  "number"
    t.string   "operator"
    t.integer  "first_digit"
    t.integer  "second_digit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "probe_questions", ["probe_definition_id"], :name => "index_probe_questions_on_probe_definition_id"

  create_table "probe_questions_probes", :id => false, :force => true do |t|
    t.integer "probe_id"
    t.integer "probe_question_id"
  end

  add_index "probe_questions_probes", ["probe_id"], :name => "index_probe_questions_probes_on_probe_id"
  add_index "probe_questions_probes", ["probe_question_id"], :name => "index_probe_questions_probes_on_probe_question_id"

  create_table "probes", :force => true do |t|
    t.date     "administered_at"
    t.integer  "score"
    t.integer  "intervention_probe_assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "probes", ["intervention_probe_assignment_id"], :name => "index_probes_on_intervention_probe_assignment_id"

  create_table "question_definitions", :force => true do |t|
    t.integer  "checklist_definition_id"
    t.text     "text"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_definitions", ["checklist_definition_id"], :name => "index_question_definitions_on_checklist_definition_id"

  create_table "quicklist_items", :force => true do |t|
    t.integer  "school_id"
    t.integer  "district_id"
    t.integer  "intervention_definition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quicklist_items", ["district_id", "school_id"], :name => "index_quicklist_items_on_district_id_and_school_id"
  add_index "quicklist_items", ["district_id"], :name => "index_quicklist_items_on_district_id"
  add_index "quicklist_items", ["intervention_definition_id"], :name => "index_quicklist_items_on_intervention_definition_id"
  add_index "quicklist_items", ["school_id"], :name => "index_quicklist_items_on_school_id"

  create_table "railmail_deliveries", :force => true do |t|
    t.string   "recipients", :limit => 1024
    t.string   "from"
    t.string   "subject",    :limit => 1024
    t.datetime "sent_at"
    t.datetime "read_at"
    t.string   "raw",        :limit => 8000
  end

  create_table "recommendation_answer_definitions", :force => true do |t|
    t.integer  "recommendation_definition_id"
    t.integer  "position"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendation_answer_definitions", ["recommendation_definition_id"], :name => "rec_def_id"

  create_table "recommendation_answers", :force => true do |t|
    t.integer  "recommendation_id"
    t.integer  "recommendation_answer_definition_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendation_answers", ["recommendation_answer_definition_id"], :name => "rec_ans_def_id"
  add_index "recommendation_answers", ["recommendation_id"], :name => "index_recommendation_answers_on_recommendation_id"

  create_table "recommendation_definitions", :force => true do |t|
    t.boolean  "active"
    t.text     "text"
    t.integer  "checklist_definition_id"
    t.integer  "score_options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendation_definitions", ["checklist_definition_id"], :name => "index_recommendation_definitions_on_checklist_definition_id"

  create_table "recommendations", :force => true do |t|
    t.integer  "progress"
    t.integer  "recommendation"
    t.integer  "checklist_id"
    t.integer  "user_id"
    t.text     "other"
    t.boolean  "should_advance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recommendation_definition_id"
    t.boolean  "draft",                        :default => false
    t.integer  "district_id"
    t.integer  "tier_id"
    t.integer  "student_id"
    t.boolean  "promoted",                     :default => false
    t.boolean  "advance_tier",                 :default => true
  end

  add_index "recommendations", ["checklist_id"], :name => "index_recommendations_on_checklist_id"
  add_index "recommendations", ["district_id"], :name => "index_recommendations_on_district_id"
  add_index "recommendations", ["recommendation_definition_id"], :name => "index_recommendations_on_recommendation_definition_id"
  add_index "recommendations", ["student_id"], :name => "index_recommendations_on_student_id"
  add_index "recommendations", ["tier_id"], :name => "index_recommendations_on_tier_id"
  add_index "recommendations", ["user_id"], :name => "index_recommendations_on_user_id"

  create_table "recommended_monitors", :force => true do |t|
    t.integer  "intervention_definition_id"
    t.integer  "probe_definition_id"
    t.string   "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommended_monitors", ["intervention_definition_id"], :name => "index_recommended_monitors_on_intervention_definition_id"
  add_index "recommended_monitors", ["probe_definition_id"], :name => "index_recommended_monitors_on_probe_definition_id"

  create_table "school_team_memberships", :force => true do |t|
    t.integer  "school_team_id"
    t.integer  "user_id"
    t.boolean  "contact",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_teams", :force => true do |t|
    t.integer  "school_id"
    t.string   "name"
    t.boolean  "anonymous",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "district_school_id"
    t.integer  "id_state"
    t.integer  "id_country"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["district_id", "district_school_id"], :name => "index_schools_on_district_id_and_id_district"

  create_table "special_user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "district_id"
    t.integer  "school_id"
    t.integer  "grouptype"
    t.string   "grade"
    t.boolean  "is_principal", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "special_user_groups", ["district_id"], :name => "index_special_user_groups_on_district_id"
  add_index "special_user_groups", ["school_id"], :name => "index_special_user_groups_on_school_id"
  add_index "special_user_groups", ["user_id"], :name => "index_special_user_groups_on_user_id"

  create_table "staff_assignments", :force => true do |t|
    t.integer "school_id"
    t.integer "user_id"
  end

  add_index "staff_assignments", ["school_id", "user_id"], :name => "index_staff_assignments_on_school_id_and_user_id"

  create_table "student_comments", :force => true do |t|
    t.integer  "student_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_comments", ["student_id"], :name => "index_student_comments_on_student_id"
  add_index "student_comments", ["user_id"], :name => "index_student_comments_on_user_id"

  create_table "students", :force => true do |t|
    t.integer  "district_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "number"
    t.string   "district_student_id", :limit => 40, :default => "", :null => false
    t.integer  "id_state"
    t.integer  "id_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthdate"
    t.boolean  "esl"
    t.boolean  "special_ed"
    t.string   "middle_name"
    t.string   "suffix"
  end

  add_index "students", ["district_id"], :name => "index_students_on_district_id"
  add_index "students", ["district_student_id"], :name => "index_students_on_id_district"
  add_index "students", ["id_state", "district_id", "birthdate", "first_name", "last_name"], :name => "null_id_state_match"
  add_index "students", ["id_state"], :name => "index_students_on_id_state"

  create_table "team_consultations", :force => true do |t|
    t.integer  "student_id"
    t.integer  "requestor_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete",     :default => false
    t.boolean  "draft",        :default => false
  end

  add_index "team_consultations", ["student_id"], :name => "index_team_consultations_on_student_id"

  create_table "tiers", :force => true do |t|
    t.integer  "district_id"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tiers", ["district_id"], :name => "index_tiers_on_district_id"

  create_table "time_lengths", :force => true do |t|
    t.string   "title"
    t.integer  "days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_group_assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "is_principal", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_group_assignments", ["group_id"], :name => "index_user_group_assignments_on_group_id"
  add_index "user_group_assignments", ["user_id"], :name => "index_user_group_assignments_on_user_id"

  create_table "user_school_assignments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "user_id"
    t.boolean  "admin",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_school_assignments", ["school_id"], :name => "index_user_school_assignments_on_school_id"
  add_index "user_school_assignments", ["user_id"], :name => "index_user_school_assignments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username",         :limit => 100
    t.binary   "passwordhash"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "middle_name"
    t.string   "suffix"
    t.string   "salt",                            :default => ""
    t.string   "district_user_id", :limit => 40,  :default => "", :null => false
    t.string   "token"
    t.integer  "roles_mask",                      :default => 0,  :null => false
  end

  add_index "users", ["district_id", "district_user_id"], :name => "index_users_on_district_id_and_id_district"
  add_index "users", ["roles_mask"], :name => "index_users_on_roles_mask"

end
