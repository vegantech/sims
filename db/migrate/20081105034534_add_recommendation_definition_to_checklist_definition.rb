class AddRecommendationDefinitionToChecklistDefinition < ActiveRecord::Migration
  def self.up
    add_column :checklist_definitions, :recommendation_definition_id, :integer
  end

  def self.down
    remove_column :checklist_definitions, :recommendation_definition_id
  end
end
