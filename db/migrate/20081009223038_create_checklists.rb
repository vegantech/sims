class CreateChecklists < ActiveRecord::Migration
  def self.up
    create_table :checklists do |t|
      t.belongs_to :checklist_definition
      t.integer :from_tier
      t.belongs_to :student
      t.boolean :promoted
      t.belongs_to :user
      t.boolean :is_draft, default: true
      t.belongs_to :district

      t.timestamps
    end
  end

  def self.down
    drop_table :checklists
  end
end
