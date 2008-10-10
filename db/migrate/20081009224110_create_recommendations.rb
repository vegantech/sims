class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|
      t.integer :progress
      t.integer :recommendation
      t.belongs_to :checklist
      t.belongs_to :user
      t.text :reason
      t.boolean :should_advance

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendations
  end
end
