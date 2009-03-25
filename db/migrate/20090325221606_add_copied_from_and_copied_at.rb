class AddCopiedFromAndCopiedAt < ActiveRecord::Migration
  def self.up
    add_column :intervention_clusters, :copied_at, :datetime
    add_column :intervention_definitions, :copied_at, :datetime
    add_column :probe_definitions, :copied_at, :datetime
    add_column :recommended_monitors, :copied_at, :datetime
    add_column :checklist_definitions, :copied_at, :datetime
    add_column :question_definitions, :copied_at, :datetime
    add_column :element_definitions, :copied_at, :datetime
    add_column :answer_definitions, :copied_at, :datetime
    add_column :probe_definition_benchmarks, :copied_at, :datetime
    add_column :probe_questions, :copied_at, :datetime
    add_column :recommendation_definitions, :copied_at, :datetime
    add_column :recommendation_answer_definitions, :copied_at, :datetime
    
    add_column :intervention_clusters, :copied_from, :integer
    add_column :intervention_definitions, :copied_from, :integer
    add_column :probe_definitions, :copied_from, :integer
    add_column :recommended_monitors, :copied_from, :integer
    add_column :checklist_definitions, :copied_from, :integer
    add_column :question_definitions, :copied_from, :integer
    add_column :element_definitions, :copied_from, :integer
    add_column :answer_definitions, :copied_from, :integer
    add_column :probe_definition_benchmarks, :copied_from, :integer
    add_column :probe_questions, :copied_from, :integer
    add_column :recommendation_definitions, :copied_from, :integer
    add_column :recommendation_answer_definitions, :copied_from, :integer
  end

  def self.down
    remove_column :recommendation_answer_definitions, :copied_from
    remove_column :recommendation_definitions, :copied_from
    remove_column :probe_questions, :copied_from
    remove_column :probe_definition_benchmarks, :copied_from
    remove_column :answer_definitions, :copied_from
    remove_column :element_definitions, :copied_from
    remove_column :question_definitions, :copied_from
    remove_column :checklist_definitions, :copied_from
    remove_column :recommended_monitors, :copied_from
    remove_column :probe_definitions, :copied_from
    remove_column :intervention_definitions, :copied_from
    remove_column :intervention_clusters, :copied_from
    
    remove_column :recommendation_answer_definitions, :copied_at
    remove_column :recommendation_definitions, :copied_at
    remove_column :probe_questions, :copied_at
    remove_column :probe_definition_benchmarks, :copied_at
    remove_column :answer_definitions, :copied_at
    remove_column :element_definitions, :copied_at
    remove_column :question_definitions, :copied_at
    remove_column :checklist_definitions, :copied_at
    remove_column :recommended_monitors, :copied_at
    remove_column :probe_definitions, :copied_at
    remove_column :intervention_definitions, :copied_at
    remove_column :intervention_clusters, :copied_at
  end
end

