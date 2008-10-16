class CreateProbeDefinitions < ActiveRecord::Migration
  def self.up
    create_table :probe_definitions do |t|
      t.string :title
      t.text :description
      t.belongs_to :user
      t.belongs_to :district
      t.boolean :active, :default=>true
      t.integer :maximum_score
      t.integer :minimum_score
      t.belongs_to :school
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :probe_definitions
  end
end
