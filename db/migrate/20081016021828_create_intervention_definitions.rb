class CreateInterventionDefinitions < ActiveRecord::Migration
  def self.up
    create_table :intervention_definitions do |t|
      t.string :title
      t.text :description
      t.boolean :custom, default: false
      t.belongs_to :intervention_cluster
      t.belongs_to :tier
      t.belongs_to :time_length
      t.integer :time_length_num, default: 1
      t.belongs_to :frequency
      t.integer :frequency_multiplier, default: 1
      t.belongs_to :user
      t.belongs_to :school
      t.boolean :disabled, default: false
      t.integer :position
      t.string :rec_mon_preface


      t.timestamps
    end
  end

  def self.down
    drop_table :intervention_definitions
  end
end
