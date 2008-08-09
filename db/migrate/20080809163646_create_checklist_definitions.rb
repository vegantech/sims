class CreateChecklistDefinitions < ActiveRecord::Migration
  def self.up
    create_table :checklist_definitions do |t|
      t.text :text
      t.text :directions
      t.boolean :active
      t.district :references

      t.timestamps
    end
  end

  def self.down
    drop_table :checklist_definitions
  end
end
