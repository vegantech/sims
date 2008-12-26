class CreateQuicklistItems < ActiveRecord::Migration
  def self.up
    create_table :quicklist_items do |t|
      t.belongs_to :school
      t.belongs_to :district
      t.belongs_to :intervention_definition

      t.timestamps
    end
  end

  def self.down
    drop_table :quicklist_items
  end
end
