class CreateRecommendationDefinitions < ActiveRecord::Migration
  def self.up
    create_table :recommendation_definitions do |t|
      t.belongs_to :district
      t.boolean :active
      t.text :text
      t.belongs_to :checklist_definition
      t.integer :score_options

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendation_definitions
  end
end
