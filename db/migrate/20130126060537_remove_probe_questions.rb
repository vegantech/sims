class RemoveProbeQuestions < ActiveRecord::Migration
  def up
    remove_index "probe_questions_probes", :name => "index_probe_questions_probes_on_probe_question_id"
    remove_index "probe_questions_probes", :name => "index_probe_questions_probes_on_probe_id"

    drop_table "probe_questions_probes"

    remove_index "probe_questions", :name => "index_probe_questions_on_probe_definition_id"

    drop_table "probe_questions"
  end

  def down
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
  end
end
