class AddRecommendationDefinitionIdToRecommendations < ActiveRecord::Migration
  def self.up
    add_column :recommendations,:recommendation_definition_id, :integer
  end

  def self.down
    remove_column :recommendations,:recommendation_definition_id
  end
end
