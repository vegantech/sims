class RemoveDeletedAt < ActiveRecord::Migration
  def self.up
    remove_column2 :recommendation_answer_definitions, :deleted_at
    remove_column2 :recommendation_definitions, :deleted_at
    remove_column2 :probe_questions, :deleted_at
    remove_column2 :probe_definition_benchmarks, :deleted_at
    remove_column2 :answer_definitions, :deleted_at
    remove_column2 :element_definitions, :deleted_at
    remove_column2 :question_definitions, :deleted_at
    remove_column2 :checklist_definitions, :deleted_at
    remove_column2 :recommended_monitors, :deleted_at
    remove_column2 :probe_definitions, :deleted_at
    remove_column2 :intervention_definitions, :deleted_at
    remove_column2 :intervention_clusters, :deleted_at
    remove_column2 :objective_definitions, :deleted_at
    remove_column2 :goal_definitions, :deleted_at
   end

  def self.down
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

  def self.remove_column2 table, column
    table.to_s.classify.constantize.delete_all("deleted_at is not null")
    remove_column(table, column)
  end
end



