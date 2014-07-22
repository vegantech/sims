class AddDeletedAtColumns < ActiveRecord::Migration
  def self.up
    add_column :goal_definitions, :deleted_at, :datetime
    add_column :objective_definitions, :deleted_at, :datetime
    add_column :intervention_clusters, :deleted_at, :datetime
    add_column :intervention_definitions, :deleted_at, :datetime
    add_column :probe_definitions, :deleted_at, :datetime
    add_column :recommended_monitors, :deleted_at, :datetime
    add_column :checklist_definitions, :deleted_at, :datetime
    add_column :question_definitions, :deleted_at, :datetime
    add_column :element_definitions, :deleted_at, :datetime
    add_column :answer_definitions, :deleted_at, :datetime
    add_column :probe_definition_benchmarks, :deleted_at, :datetime
    add_column :probe_questions, :deleted_at, :datetime
    add_column :recommendation_definitions, :deleted_at, :datetime
    add_column :recommendation_answer_definitions, :deleted_at, :datetime
  end

  def self.down
    remove_column :recommendation_answer_definitions, :deleted_at
    remove_column :recommendation_definitions, :deleted_at
    remove_column :probe_questions, :deleted_at
    remove_column :probe_definition_benchmarks, :deleted_at
    remove_column :answer_definitions, :deleted_at
    remove_column :element_definitions, :deleted_at
    remove_column :question_definitions, :deleted_at
    remove_column :checklist_definitions, :deleted_at
    remove_column :recommended_monitors, :deleted_at
    remove_column :probe_definitions, :deleted_at
    remove_column :intervention_definitions, :deleted_at
    remove_column :intervention_clusters, :deleted_at
    remove_column :objective_definitions, :deleted_at
    remove_column :goal_definitions, :deleted_at
  end
end
