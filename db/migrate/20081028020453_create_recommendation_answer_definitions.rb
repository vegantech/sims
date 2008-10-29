class CreateRecommendationAnswerDefinitions < ActiveRecord::Migration
  def self.up
    create_table :recommendation_answer_definitions do |t|
      t.belongs_to :recommendation_definition
      t.integer :position
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendation_answer_definitions
  end
end
