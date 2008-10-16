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

ActiveRecord::Schema.define(:version => 20081016153827) do

  create_table "answer_definitions", :force => true do |t|
    t.integer  "element_definition_id"
    t.text     "text"
    t.string   "value"
    t.integer  "position"
    t.boolean  "autoset_others"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "checklist_id"
    t.integer  "answer_definition_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checklist_definitions", :force => true do |t|
    t.text     "text"
    t.text     "directions"
    t.boolean  "active"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.integer  "state_dpi_num"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "element_definitions", :force => true do |t|
    t.integer  "question_definition_id"
    t.text     "text"
    t.string   "kind"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "student_id"
    t.string   "grade",      :limit => 16
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flags", :force => true do |t|
    t.string   "category"
    t.integer  "user_id"
    t.integer  "district_id"
    t.integer  "student_id"
    t.text     "reason"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "intervention_clusters", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "objective_definition_id"
    t.integer  "position"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "disabled",                :default => false
    t.integer  "position"
    t.string   "rec_mon_preface"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "objective_definitions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "goal_definition_id"
    t.integer  "position"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "probe_definition_benchmarks", :force => true do |t|
    t.integer  "probe_definition_id"
    t.integer  "benchmark"
    t.integer  "district_id"
    t.integer  "grade_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "question_definitions", :force => true do |t|
    t.integer  "checklist_definition_id"
    t.text     "text"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "progress"
    t.integer  "recommendation"
    t.integer  "checklist_id"
    t.integer  "user_id"
    t.text     "reason"
    t.boolean  "should_advance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "id_district"
    t.integer  "id_state"
    t.integer  "id_country"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "school_id"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_comments", :force => true do |t|
    t.integer  "student_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.integer  "district_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "number"
    t.integer  "id_district"
    t.integer  "id_state"
    t.integer  "id_country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_lengths", :force => true do |t|
    t.string   "title"
    t.integer  "days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.binary   "passwordhash"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
